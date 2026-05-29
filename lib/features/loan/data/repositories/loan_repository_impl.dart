import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
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
}