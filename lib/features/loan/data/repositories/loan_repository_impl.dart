import 'package:fpdart/fpdart.dart';
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
}