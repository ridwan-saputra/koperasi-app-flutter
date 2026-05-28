import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart'; // Pastikan ini di-import untuk menangkap DatabaseException
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper dbHelper;

  AuthRepositoryImpl(this.dbHelper);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    // ... (Kode login biarkan sama persis seperti sebelumnya) ...
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isEmpty) {
        return Left(AuthFailure('Email tidak ditemukan.'));
      }

      final userMap = maps.first;

      if (userMap['password_hash'] != password) {
        return Left(AuthFailure('Password salah.'));
      }

      final user = UserEntity.fromJson(userMap);
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Terjadi kesalahan database: ${e.toString()}'));
    }
  }

  // --- TAMBAHKAN FUNGSI REGISTER DI BAWAH INI ---
  @override
  Future<Either<Failure, UserEntity>> register(UserEntity user) async {
    try {
      final db = await dbHelper.database;
      
      // Ubah Entity menjadi bentuk Map (JSON) agar bisa dibaca SQLite
      final userMap = user.toJson();
      
      // Insert ke tabel 'users'
      await db.insert(
        'users',
        userMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return Right(user);
    } on DatabaseException catch (e) {
      // Menangkap error jika NIK atau Email sudah ada (karena di tabel kita set UNIQUE)
      if (e.isUniqueConstraintError()) {
        return Left(AuthFailure('Email atau NIK sudah terdaftar.'));
      }
      return Left(DatabaseFailure('Gagal mendaftar: ${e.toString()}'));
    } catch (e) {
      return Left(DatabaseFailure('Terjadi kesalahan sistem: ${e.toString()}'));
    }
  }
}