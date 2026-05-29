import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  final DatabaseHelper dbHelper;

  LoanRepositoryImpl(this.dbHelper);

  @override
  Future<Either<Failure, LoanEntity>> applyLoan(LoanEntity loan) async {
    try {
      final db = await dbHelper.database;
      
      // Mengubah objek Entity menjadi Map JSON untuk disimpan ke SQLite
      await db.insert(
        'loans',
        loan.toJson(),
      );

      return Right(loan);
    } catch (e) {
      return Left(DatabaseFailure('Gagal mengajukan pinjaman: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LoanEntity>>> getPendingLoans() async {
    try {
      final db = await dbHelper.database;
      
      // Ambil data yang statusnya PENDING saja, urutkan dari yang terlama
      final List<Map<String, dynamic>> maps = await db.query(
        'loans',
        where: 'status = ?',
        whereArgs: ['PENDING'],
        orderBy: 'created_at ASC', 
      );

      final List<LoanEntity> loans = maps.map((map) => LoanEntity.fromJson(map)).toList();
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
      
      // Menggunakan Transaction agar Update dan Insert berjalan atomik bersamaan
      await db.transaction((txn) async {
        // 1. Update status di tabel loans
        await txn.update(
          'loans',
          {
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [loanId],
        );

        // 2. Catat rekam jejak admin di tabel admin_actions
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
}