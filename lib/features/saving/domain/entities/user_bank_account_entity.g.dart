// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bank_account_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBankAccountEntityImpl _$$UserBankAccountEntityImplFromJson(
  Map<String, dynamic> json,
) => _$UserBankAccountEntityImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  bankCode: json['bank_code'] as String,
  bankName: json['bank_name'] as String,
  accountNumber: json['account_number'] as String,
  accountHolder: json['account_holder'] as String,
  isPrimary: json['is_primary'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$UserBankAccountEntityImplToJson(
  _$UserBankAccountEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'bank_code': instance.bankCode,
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder': instance.accountHolder,
  'is_primary': instance.isPrimary,
  'created_at': instance.createdAt.toIso8601String(),
};
