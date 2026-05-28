import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart'; // Baris import yang ditambahkan
import '../../data/repositories/saving_repository_impl.dart';
import '../../domain/repositories/saving_repository.dart';
import '../../domain/entities/transaction_entity.dart';

// 1. Provider untuk Repository Simpanan
final savingRepositoryProvider = Provider<SavingRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider); 
  return SavingRepositoryImpl(dbHelper);
});

// 2. Controller untuk State Saldo (Balance)
class BalanceNotifier extends StateNotifier<AsyncValue<double>> {
  final SavingRepository _repository;

  // Awal mula status adalah loading
  BalanceNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchBalance(String userId) async {
    state = const AsyncValue.loading();
    final result = await _repository.getTotalBalance(userId);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (balance) => state = AsyncValue.data(balance),
    );
  }

  Future<bool> makeDeposit(TransactionEntity transaction) async {
    final result = await _repository.deposit(transaction);
    
    return result.fold(
      (failure) {
        // Jika gagal, biarkan state saldo seperti sebelumnya, tapi kembalikan nilai false
        return false; 
      },
      (newTransaction) {
        // Jika sukses deposit, perbarui ulang saldo dari database
        fetchBalance(newTransaction.userId);
        return true;
      },
    );
  }
}

// 3. Provider yang akan dipanggil oleh UI Dashboard User
final balanceNotifierProvider = StateNotifierProvider<BalanceNotifier, AsyncValue<double>>((ref) {
  final repository = ref.watch(savingRepositoryProvider);
  return BalanceNotifier(repository);
});

// 4. Provider untuk memuat Riwayat Transaksi (FutureProvider)
final historyProvider = FutureProvider.family<List<TransactionEntity>, String>((ref, userId) async {
  final repository = ref.watch(savingRepositoryProvider);
  final result = await repository.getTransactionHistory(userId);
  
  return result.fold(
    (failure) => throw Exception(failure.message), // Lempar error jika gagal
    (history) => history, // Kembalikan list transaksi jika sukses
  );
});