import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_bank_account_entity.dart';
import '../../domain/repositories/bank_account_repository.dart';

class BankAccountRepositoryImpl implements BankAccountRepository {
  BankAccountRepositoryImpl(this.dbHelper);

  final DatabaseHelper dbHelper;

  Map<String, dynamic> _toDbMap(UserBankAccountEntity account) {
    final map = account.toJson();
    map['is_primary'] = account.isPrimary ? 1 : 0;
    return map;
  }

  UserBankAccountEntity _fromDbMap(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    copy['is_primary'] = (map['is_primary'] as int) == 1;
    return UserBankAccountEntity.fromJson(copy);
  }

  @override
  Future<Either<Failure, List<UserBankAccountEntity>>> getAccountsByUser(
    String userId,
  ) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'user_bank_accounts',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'is_primary DESC, created_at DESC',
      );
      return Right(maps.map(_fromDbMap).toList());
    } catch (e) {
      return Left(DatabaseFailure('Gagal memuat rekening bank: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserBankAccountEntity>> saveAccount(
    UserBankAccountEntity account,
  ) async {
    try {
      final db = await dbHelper.database;
      await db.transaction((txn) async {
        if (account.isPrimary) {
          await txn.update(
            'user_bank_accounts',
            {'is_primary': 0},
            where: 'user_id = ?',
            whereArgs: [account.userId],
          );
        }
        await txn.insert(
          'user_bank_accounts',
          _toDbMap(account),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return Right(account);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan rekening: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(String accountId, String userId) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'user_bank_accounts',
        where: 'id = ? AND user_id = ?',
        whereArgs: [accountId, userId],
      );
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menghapus rekening: ${e.toString()}'));
    }
  }
}
