import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/loan_repository_impl.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';

// 1. Provider untuk akses Repository
final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return LoanRepositoryImpl(dbHelper);
});

// 2. Notifier untuk mengontrol state submisi pinjaman (AsyncValue)
class LoanNotifier extends StateNotifier<AsyncValue<LoanEntity?>> {
  final LoanRepository _repository;

  LoanNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<bool> submitLoan(LoanEntity loan) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.applyLoan(loan);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (successData) {
        state = AsyncValue.data(successData);
        return true;
      },
    );
  }
}

// 3. Provider utama yang akan didengarkan oleh UI Review
final loanNotifierProvider = StateNotifierProvider<LoanNotifier, AsyncValue<LoanEntity?>>((ref) {
  final repository = ref.watch(loanRepositoryProvider);
  return LoanNotifier(repository);
});