import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/loan_entity.dart';

abstract class LoanRepository {
  // Fungsi mengajukan pinjaman
  Future<Either<Failure, LoanEntity>> applyLoan(LoanEntity loan);

  // Mengambil daftar semua pinjaman yang masih PENDING
  Future<Either<Failure, List<LoanEntity>>> getPendingLoans();
  
  // Memproses pinjaman (Approve/Reject) sekaligus mencatat ke Audit Trail
  Future<Either<Failure, bool>> processLoanStatus({
    required String loanId,
    required String adminId,
    required String status, // 'APPROVED' atau 'REJECTED'
    required String remarks,
  });
}