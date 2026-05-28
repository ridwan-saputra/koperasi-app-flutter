import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/saving_repository.dart';

class SavingRepositoryImpl implements SavingRepository {
  final DatabaseHelper dbHelper;

  SavingRepositoryImpl(this.dbHelper);

  @override
  Future<Either<Failure, double>> getTotalBalance(String userId) async {
    try {
      final db = await dbHelper.database;
      
      // Menggunakan SQL SUM untuk menjumlahkan semua nominal dengan status SUCCESS
      final result = await db.rawQuery(
        "SELECT SUM(nominal) as total FROM transactions WHERE user_id = ? AND status = 'SUCCESS'",
        [userId],
      );

      double total = 0.0;
      if (result.isNotEmpty && result.first['total'] != null) {
        total = (result.first['total'] as num).toDouble();
      }

      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat saldo: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> deposit(TransactionEntity transaction) async {
    try {
      final db = await dbHelper.database;
      
      await db.insert(
        'transactions',
        transaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure('Transaksi gagal: ${e.toString()}'));
    }
  }
}