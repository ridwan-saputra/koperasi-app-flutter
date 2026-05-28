// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionEntityImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  type: json['type'] as String,
  nominal: (json['nominal'] as num).toDouble(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$TransactionEntityImplToJson(
  _$TransactionEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'type': instance.type,
  'nominal': instance.nominal,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
};
