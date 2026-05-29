import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/loan_entity.dart';
import 'loan_provider.dart';

final pendingLoansProvider = FutureProvider.autoDispose<List<LoanEntity>>((ref) async {
  final repository = ref.watch(loanRepositoryProvider);
  final result = await repository.getPendingLoans();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (loans) => loans,
  );
});

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
      loanId: loanId, adminId: adminId, status: status, remarks: remarks,
    );
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(pendingLoansProvider);
        return true;
      },
    );
  }
}

final adminActionProvider = StateNotifierProvider<AdminActionNotifier, AsyncValue<void>>((ref) {
  return AdminActionNotifier(ref);
});

// Provider baru untuk Daftar Anggota
final allMembersProvider = FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final repository = ref.watch(loanRepositoryProvider);
  final result = await repository.getAllMembers();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (members) => members,
  );
});