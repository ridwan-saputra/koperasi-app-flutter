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
      
      // Karena kita pakai Freezed, pastikan namaPeminjam tidak ikut ter-insert ke tabel loans
      final Map<String, dynamic> loanData = loan.toJson();
      loanData.remove('nama_lengkap'); 

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
      
      // Menggunakan INNER JOIN untuk menarik nama_lengkap anggota
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
      return Left(DatabaseFailure('Gagal memuat daftar antrean pinjaman: ${e.toString()}'));
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
        await txn.update(
          'loans',
          {'status': status, 'updated_at': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [loanId],
        );
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
      });
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memproses status pinjaman: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllMembers() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['USER'],
        orderBy: 'nama_lengkap ASC',
      );
      final List<UserEntity> members = maps.map((map) => UserEntity.fromJson(map)).toList();
      return Right(members);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat daftar anggota: ${e.toString()}'));
    }
  }
}