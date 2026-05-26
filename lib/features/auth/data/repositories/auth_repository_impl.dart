import 'package:fpdart/fpdart.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper dbHelper;

  AuthRepositoryImpl(this.dbHelper);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final db = await dbHelper.database;

      // Mencari user berdasarkan email di SQLite
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isEmpty) {
        return Left(AuthFailure('Email tidak ditemukan.'));
      }

      final userMap = maps.first;

      // Cek kecocokan password (Di production nyata, kita akan pakai bcrypt)
      if (userMap['password_hash'] != password) {
        return Left(AuthFailure('Password salah.'));
      }

      // Jika berhasil, ubah data SQLite (Map) menjadi UserEntity
      final user = UserEntity.fromJson(userMap);
      return Right(user);
    } catch (e) {
      return Left(
        DatabaseFailure('Terjadi kesalahan pada database: ${e.toString()}'),
      );
    }
  }
}
