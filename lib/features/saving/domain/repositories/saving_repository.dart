import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';

abstract class SavingRepository {
  // Fungsi untuk mengambil total saldo berdasarkan ID User
  Future<Either<Failure, double>> getTotalBalance(String userId);
  
  // Fungsi untuk memasukkan data simpanan baru
  Future<Either<Failure, TransactionEntity>> deposit(TransactionEntity transaction);

  // Fungsi untuk mengambil riwayat transaksi berdasarkan ID User
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory(String userId);

  Future<Either<Failure, TransactionEntity>> requestWithdraw(TransactionEntity transaction);

  Future<Either<Failure, List<TransactionEntity>>> getPendingWithdrawals();

  Future<Either<Failure, bool>> processWithdrawStatus({
    required String transactionId,
    required String status,
  });
}