import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_entity.dart';
import 'loan_provider.dart';

// 1. Provider untuk mengambil daftar pinjaman yang berstatus PENDING
final pendingLoansProvider = FutureProvider.autoDispose<List<LoanEntity>>((ref) async {
  final repository = ref.watch(loanRepositoryProvider);
  final result = await repository.getPendingLoans();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (loans) => loans,
  );
});

// 2. Controller untuk memproses persetujuan/penolakan pinjaman
class AdminActionNotifier extends StateNotifier<AsyncValue<void>> {
  AdminActionNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<bool> processLoan({
    required String loanId,
    required String adminId,
    required String status,
    required String remarks,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(loanRepositoryProvider);
    
    final result = await repository.processLoanStatus(
      loanId: loanId,
      adminId: adminId,
      status: status,
      remarks: remarks,
    );
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        // Penting: Instruksikan Riverpod untuk memuat ulang daftar antrean
        ref.invalidate(pendingLoansProvider);
        return true;
      },
    );
  }
}

// 3. Provider yang akan dipanggil oleh UI Admin
final adminActionProvider = StateNotifierProvider<AdminActionNotifier, AsyncValue<void>>((ref) {
  return AdminActionNotifier(ref);
});