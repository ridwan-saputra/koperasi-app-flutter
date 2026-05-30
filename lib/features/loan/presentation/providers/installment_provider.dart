import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../saving/presentation/providers/saving_provider.dart';
import '../../domain/entities/loan_entity.dart';
import 'loan_provider.dart';

final activeLoansProvider =
    FutureProvider.autoDispose.family<List<LoanEntity>, String>((ref, userId) async {
  final repository = ref.watch(loanRepositoryProvider);
  final result = await repository.getApprovedLoansByUser(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (loans) => loans,
  );
});

final paidInstallmentCountProvider =
    FutureProvider.autoDispose.family<int, String>((ref, loanId) async {
  final repository = ref.watch(loanRepositoryProvider);
  final result = await repository.getPaidInstallmentCount(loanId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (count) => count,
  );
});

class InstallmentNotifier extends StateNotifier<AsyncValue<void>> {
  InstallmentNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> payInstallment({
    required String loanId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(loanRepositoryProvider);
    final result = await repository.payInstallment(loanId: loanId, userId: userId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(activeLoansProvider(userId));
        ref.invalidate(paidInstallmentCountProvider(loanId));
        ref.invalidate(historyProvider(userId));
        ref.read(balanceNotifierProvider.notifier).fetchBalance(userId);
        return true;
      },
    );
  }
}

final installmentNotifierProvider =
    StateNotifierProvider<InstallmentNotifier, AsyncValue<void>>((ref) {
  return InstallmentNotifier(ref);
});
