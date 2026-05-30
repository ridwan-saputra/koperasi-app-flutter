import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../saving/domain/entities/transaction_entity.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  final DatabaseHelper dbHelper;

  LoanRepositoryImpl(this.dbHelper);

@override
  Future<Either<Failure, LoanEntity>> applyLoan(LoanEntity loan) async {
    try {
      final db = await dbHelper.database;
      final Map<String, dynamic> loanData = loan.toJson();
      loanData.remove('nama_lengkap'); 
      
      // --- TAMBAHAN FIX ---
      // Mengakali constraint NOT NULL di database lama tanpa harus Clear Data
      loanData['rekening_tujuan'] = 'SALDO_APLIKASI'; 

      await db.insert('loans', loanData);
      return Right(loan);
    } catch (e) {
      return Left(DatabaseFailure('Gagal mengajukan pinjaman: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LoanEntity>>> getPendingLoans() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT loans.*, users.nama_lengkap 
        FROM loans
        INNER JOIN users ON loans.user_id = users.id
        WHERE loans.status = 'PENDING'
        ORDER BY loans.created_at ASC
      ''');
      final List<LoanEntity> loans = results.map((map) => LoanEntity.fromJson(map)).toList();
      return Right(loans);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat antrean: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> processLoanStatus({
    required String loanId, 
    required String adminId, 
    required String status, 
    required String remarks
  }) async {
    try {
      final db = await dbHelper.database;
      await db.transaction((txn) async {
        
        // 1. Update status pinjaman di tabel loans
        await txn.update(
          'loans',
          {'status': status, 'updated_at': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [loanId],
        );

        // 2. Catat jejak aksi Admin di tabel admin_actions
        await txn.insert(
          'admin_actions',
          {
            'id': const Uuid().v4(),
            'admin_id': adminId,
            'loan_id': loanId,
            'action': status,
            'remarks': remarks,
            'created_at': DateTime.now().toIso8601String(),
          },
        );

        // 3. LOGIKA PENCAIRAN OTOMATIS KE SALDO (SUDAH DISINKRONKAN DENGAN DATABASE KAMU)
        if (status == 'APPROVED') {
          final loanData = await txn.query('loans', where: 'id = ?', whereArgs: [loanId]);
          
          if (loanData.isNotEmpty) {
            final userId = loanData.first['user_id'] as String;
            final nominalPokok = (loanData.first['nominal_pokok'] as num).toDouble();

            // Memasukkan data transaksi sesuai struktur tabel database koperasi.db milikmu
            await txn.insert(
              'transactions',
              {
                'id': const Uuid().v4(),
                'user_id': userId,
                'type': 'DEPOSIT',       // Bertipe pemasukan agar menambah saldo simpanan aplikasi
                'nominal': nominalPokok,   // Menggunakan nama kolom databasemu
                'status': 'SUCCESS',     // Status langsung sukses karena pencairan instan
                'created_at': DateTime.now().toIso8601String(),
              },
            );
          }
        }
      });
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memproses pinjaman: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllMembers() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users', where: 'role = ?', whereArgs: ['USER'], orderBy: 'nama_lengkap ASC',
      );
      return Right(maps.map((map) => UserEntity.fromJson(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat anggota: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LoanEntity>>> getApprovedLoansByUser(String userId) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'loans',
        where: 'user_id = ? AND status = ?',
        whereArgs: [userId, 'APPROVED'],
        orderBy: 'created_at DESC',
      );
      return Right(maps.map((map) => LoanEntity.fromJson(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat pinjaman aktif: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getPaidInstallmentCount(String loanId) async {
    try {
      final db = await dbHelper.database;
      final result = await db.rawQuery(
        '''
        SELECT COUNT(*) AS count FROM transactions
        WHERE loan_id = ? AND type = 'CICILAN' AND status = 'SUCCESS'
        ''',
        [loanId],
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return Right(count);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat progres cicilan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> payInstallment({
    required String loanId,
    required String userId,
  }) async {
    try {
      final db = await dbHelper.database;
      Failure? failure;
      TransactionEntity? transaction;

      await db.transaction((txn) async {
        final loanMaps = await txn.query(
          'loans',
          where: 'id = ? AND user_id = ?',
          whereArgs: [loanId, userId],
        );
        if (loanMaps.isEmpty) {
          failure = DatabaseFailure('Pinjaman tidak ditemukan.');
          return;
        }

        final loan = LoanEntity.fromJson(loanMaps.first);
        if (loan.status != 'APPROVED') {
          failure = DatabaseFailure('Pinjaman tidak aktif untuk pembayaran cicilan.');
          return;
        }

        final paidResult = await txn.rawQuery(
          '''
          SELECT COUNT(*) AS count FROM transactions
          WHERE loan_id = ? AND type = 'CICILAN' AND status = 'SUCCESS'
          ''',
          [loanId],
        );
        final paidCount = Sqflite.firstIntValue(paidResult) ?? 0;
        if (paidCount >= loan.tenorBulan) {
          failure = DatabaseFailure('Semua cicilan pinjaman ini sudah lunas.');
          return;
        }

        final balanceResult = await txn.rawQuery(
          '''
          SELECT
            COALESCE(SUM(CASE WHEN type = 'DEPOSIT' THEN nominal ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN type = 'CICILAN' THEN nominal ELSE 0 END), 0) AS total
          FROM transactions
          WHERE user_id = ? AND status = 'SUCCESS'
          ''',
          [userId],
        );
        final balance = (balanceResult.first['total'] as num?)?.toDouble() ?? 0;
        if (balance < loan.cicilanPerBulan) {
          failure = DatabaseFailure(
            'Saldo tidak mencukupi. Diperlukan ${CurrencyFormatter.format(loan.cicilanPerBulan)}.',
          );
          return;
        }

        transaction = TransactionEntity(
          id: const Uuid().v4(),
          userId: userId,
          type: 'CICILAN',
          nominal: loan.cicilanPerBulan,
          status: 'SUCCESS',
          loanId: loanId,
          createdAt: DateTime.now(),
        );

        await txn.insert('transactions', transaction!.toJson());

        if (paidCount + 1 >= loan.tenorBulan) {
          await txn.update(
            'loans',
            {
              'status': 'COMPLETED',
              'updated_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [loanId],
          );
        }
      });

      if (failure != null) return Left(failure!);
      if (transaction == null) {
        return Left(DatabaseFailure('Gagal memproses pembayaran cicilan.'));
      }
      return Right(transaction!);
    } catch (e) {
      return Left(DatabaseFailure('Gagal membayar cicilan: ${e.toString()}'));
    }
  }
}