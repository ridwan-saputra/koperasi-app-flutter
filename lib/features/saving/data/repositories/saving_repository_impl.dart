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
  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory(String userId) async {
    try {
      final db = await dbHelper.database;
      
      // Ambil data transaksi berdasarkan user_id, urutkan dari yang terbaru
      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      // Ubah dari bentuk Map (JSON SQLite) menjadi List of Entity
      final List<TransactionEntity> history = maps.map((map) => TransactionEntity.fromJson(map)).toList();

      return Right(history);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat riwayat transaksi: ${e.toString()}'));
    }
  }
}