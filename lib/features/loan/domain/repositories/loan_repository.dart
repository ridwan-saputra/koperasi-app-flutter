import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../saving/domain/entities/transaction_entity.dart';
import '../entities/loan_entity.dart';

abstract class LoanRepository {
  Future<Either<Failure, LoanEntity>> applyLoan(LoanEntity loan);

  Future<Either<Failure, List<LoanEntity>>> getPendingLoans();
  
  Future<Either<Failure, bool>> processLoanStatus({
    required String loanId,
    required String adminId,
    required String status,
    required String remarks,
  });

  // Fungsi baru: Mengambil daftar semua anggota (bukan admin)
  Future<Either<Failure, List<UserEntity>>> getAllMembers();

  Future<Either<Failure, List<LoanEntity>>> getApprovedLoansByUser(String userId);

  Future<Either<Failure, int>> getPaidInstallmentCount(String loanId);

  Future<Either<Failure, TransactionEntity>> payInstallment({
    required String loanId,
    required String userId,
  });
}