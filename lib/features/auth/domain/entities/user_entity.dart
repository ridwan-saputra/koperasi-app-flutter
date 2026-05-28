import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String role,
    required String nik,
    @JsonKey(name: 'nama_lengkap') required String namaLengkap,
    required String email,
    @JsonKey(name: 'no_hp') required String noHp,
    @JsonKey(name: 'password_hash') required String passwordHash,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);
}