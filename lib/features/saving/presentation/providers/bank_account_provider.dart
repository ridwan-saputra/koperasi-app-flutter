import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/bank_account_repository_impl.dart';
import '../../domain/entities/user_bank_account_entity.dart';
import '../../domain/repositories/bank_account_repository.dart';

final bankAccountRepositoryProvider = Provider<BankAccountRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return BankAccountRepositoryImpl(dbHelper);
});

final userBankAccountsProvider =
    FutureProvider.autoDispose.family<List<UserBankAccountEntity>, String>((ref, userId) async {
  final repository = ref.watch(bankAccountRepositoryProvider);
  final result = await repository.getAccountsByUser(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (accounts) => accounts,
  );
});

class BankAccountNotifier extends StateNotifier<AsyncValue<void>> {
  BankAccountNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> saveAccount(UserBankAccountEntity account) async {
    state = const AsyncValue.loading();
    final repository = ref.read(bankAccountRepositoryProvider);
    final result = await repository.saveAccount(account);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(userBankAccountsProvider(account.userId));
        return true;
      },
    );
  }

  Future<bool> deleteAccount(String accountId, String userId) async {
    state = const AsyncValue.loading();
    final repository = ref.read(bankAccountRepositoryProvider);
    final result = await repository.deleteAccount(accountId, userId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(userBankAccountsProvider(userId));
        return true;
      },
    );
  }
}

final bankAccountNotifierProvider =
    StateNotifierProvider<BankAccountNotifier, AsyncValue<void>>((ref) {
  return BankAccountNotifier(ref);
});
