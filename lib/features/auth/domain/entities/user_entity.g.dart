// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      nik: json['nik'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      email: json['email'] as String,
      noHp: json['no_hp'] as String,
      passwordHash: json['password_hash'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'nik': instance.nik,
      'nama_lengkap': instance.namaLengkap,
      'email': instance.email,
      'no_hp': instance.noHp,
      'password_hash': instance.passwordHash,
      'created_at': instance.createdAt.toIso8601String(),
    };
