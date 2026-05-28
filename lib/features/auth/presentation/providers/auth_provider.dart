import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

// 1. Menyediakan instance DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// 2. Menyediakan AuthRepository (menggabungkan dbHelper ke dalam Data Layer)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return AuthRepositoryImpl(dbHelper);
});

// 3. Controller untuk State Login dan Register di UI
class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _repository;

  // Nilai awal adalah null (belum ada user yang login)
  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    // Ubah state menjadi loading
    state = const AsyncValue.loading();
    
    // Panggil fungsi login dari layer Data
    final result = await _repository.login(email, password);
    
    result.fold(
      (failure) {
        // Jika gagal, kembalikan pesan error ke UI
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        // Jika sukses, simpan data user ke dalam state
        state = AsyncValue.data(user);
      },
    );
  }

  Future<void> register(UserEntity newUser) async {
    // Ubah state menjadi loading
    state = const AsyncValue.loading();
    
    // Panggil fungsi register dari layer Data
    final result = await _repository.register(newUser);
    
    result.fold(
      (failure) {
        // Jika gagal, kembalikan pesan error ke UI
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) {
        // Jika sukses register, kita langsung anggap user tersebut login
        state = AsyncValue.data(user);
      },
    );
  }
  
  void logout() {
    state = const AsyncValue.data(null);
  }
}

// 4. Provider utama yang akan dipanggil langsung oleh Halaman UI
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});