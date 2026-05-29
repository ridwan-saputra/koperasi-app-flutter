import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/loan_entity.dart';

abstract class LoanRepository {
  Future<Either<Failure, LoanEntity>> applyLoan(LoanEntity loan);
}