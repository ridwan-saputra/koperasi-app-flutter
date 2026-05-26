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
      namaLengkap: json['namaLengkap'] as String,
      email: json['email'] as String,
      noHp: json['noHp'] as String,
      passwordHash: json['passwordHash'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'nik': instance.nik,
      'namaLengkap': instance.namaLengkap,
      'email': instance.email,
      'noHp': instance.noHp,
      'passwordHash': instance.passwordHash,
      'createdAt': instance.createdAt.toIso8601String(),
    };
