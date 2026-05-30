import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_entity.dart';
import 'bank_account_provider.dart';
import 'saving_provider.dart';

final pendingWithdrawalsProvider =
    FutureProvider.autoDispose<List<TransactionEntity>>((ref) async {
  final repository = ref.watch(savingRepositoryProvider);
  final result = await repository.getPendingWithdrawals();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) => items,
  );
});

class WithdrawNotifier extends StateNotifier<AsyncValue<void>> {
  WithdrawNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> requestWithdraw(TransactionEntity transaction) async {
    state = const AsyncValue.loading();
    final repository = ref.read(savingRepositoryProvider);
    final result = await repository.requestWithdraw(transaction);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(historyProvider(transaction.userId));
        ref.read(balanceNotifierProvider.notifier).fetchBalance(transaction.userId);
        return true;
      },
    );
  }
}

final withdrawNotifierProvider =
    StateNotifierProvider<WithdrawNotifier, AsyncValue<void>>((ref) {
  return WithdrawNotifier(ref);
});

class AdminWithdrawNotifier extends StateNotifier<AsyncValue<void>> {
  AdminWithdrawNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> processWithdraw({
    required String transactionId,
    required String userId,
    required bool isApprove,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(savingRepositoryProvider);
    final status = isApprove ? 'SUCCESS' : 'REJECTED';
    final result = await repository.processWithdrawStatus(
      transactionId: transactionId,
      status: status,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(pendingWithdrawalsProvider);
        ref.invalidate(historyProvider(userId));
        ref.read(balanceNotifierProvider.notifier).fetchBalance(userId);
        return true;
      },
    );
  }
}

final adminWithdrawNotifierProvider =
    StateNotifierProvider<AdminWithdrawNotifier, AsyncValue<void>>((ref) {
  return AdminWithdrawNotifier(ref);
});
