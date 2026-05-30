import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/constants/supported_banks.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/saving_repository.dart';
import '../transaction_db_mapper.dart';

class SavingRepositoryImpl implements SavingRepository {
  SavingRepositoryImpl(this.dbHelper);

  final DatabaseHelper dbHelper;

  /// Saldo tersedia: deposit sukses dikurangi cicilan, withdraw sukses, dan withdraw pending.
  Future<Either<Failure, double>> _getAvailableBalance(DatabaseExecutor db, String userId) async {
    final result = await db.rawQuery(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'DEPOSIT' AND status = 'SUCCESS' THEN nominal ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN type = 'CICILAN' AND status = 'SUCCESS' THEN nominal ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN type = 'WITHDRAW' AND status IN ('SUCCESS', 'PENDING') THEN nominal ELSE 0 END), 0) AS total
      FROM transactions
      WHERE user_id = ?
      ''',
      [userId],
    );

    final total = (result.first['total'] as num?)?.toDouble() ?? 0;
    return Right(total);
  }

  @override
  Future<Either<Failure, double>> getTotalBalance(String userId) async {
    try {
      final db = await dbHelper.database;
      final result = await _getAvailableBalance(db, userId);
      return result;
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
        transactionToDbMap(transaction),
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

      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      final List<TransactionEntity> history =
          maps.map((map) => TransactionEntity.fromJson(map)).toList();

      return Right(history);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat riwayat transaksi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> requestWithdraw(
    TransactionEntity transaction,
  ) async {
    try {
      final db = await dbHelper.database;
      Failure? failure;

      await db.transaction((txn) async {
        final balanceResult = await _getAvailableBalance(txn, transaction.userId);
        final balance = balanceResult.fold((_) => 0.0, (value) => value);

        if (transaction.nominal < kMinWithdrawAmount) {
          failure = DatabaseFailure(
            'Minimal penarikan ${CurrencyFormatter.format(kMinWithdrawAmount)}',
          );
          return;
        }

        if (balance < transaction.nominal) {
          failure = DatabaseFailure(
            'Saldo tidak mencukupi. Saldo tersedia ${CurrencyFormatter.format(balance)}',
          );
          return;
        }

        await txn.insert('transactions', transactionToDbMap(transaction));
      });

      if (failure != null) return Left(failure!);
      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure('Gagal mengajukan penarikan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getPendingWithdrawals() async {
    try {
      final db = await dbHelper.database;
      final results = await db.rawQuery('''
        SELECT transactions.*, users.nama_lengkap
        FROM transactions
        INNER JOIN users ON transactions.user_id = users.id
        WHERE transactions.type = 'WITHDRAW' AND transactions.status = 'PENDING'
        ORDER BY transactions.created_at ASC
      ''');

      return Right(results.map((m) => TransactionEntity.fromJson(m)).toList());
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat antrean penarikan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> processWithdrawStatus({
    required String transactionId,
    required String status,
  }) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'transactions',
        {'status': status},
        where: 'id = ? AND type = ?',
        whereArgs: [transactionId, 'WITHDRAW'],
      );
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Gagal memproses penarikan: ${e.toString()}'));
    }
  }
}
