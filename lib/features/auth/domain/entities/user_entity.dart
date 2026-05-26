import 'package:freezed_annotation/freezed_annotation.dart';

// Baris ini akan error merah (garis bawah merah) sebelum kita menjalankan build_runner.
// Biarkan saja dulu, ini normal.
part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String role, // Akan berisi 'USER' atau 'ADMIN'
    required String nik,
    required String namaLengkap,
    required String email,
    required String noHp,
    required String
    passwordHash, // Praktik arsitektur backend: jangan gunakan plain password
    required DateTime createdAt,
  }) = _UserEntity;

  // Fungsi untuk konversi data dari/ke SQLite atau API (JSON)
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
