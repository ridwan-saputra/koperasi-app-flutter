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
  loanId: json['loan_id'] as String?,
  bankCode: json['bank_code'] as String?,
  bankName: json['bank_name'] as String?,
  accountNumber: json['account_number'] as String?,
  accountHolder: json['account_holder'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  namaPemohon: json['nama_lengkap'] as String?,
);

Map<String, dynamic> _$$TransactionEntityImplToJson(
  _$TransactionEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'type': instance.type,
  'nominal': instance.nominal,
  'status': instance.status,
  'loan_id': instance.loanId,
  'bank_code': instance.bankCode,
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder': instance.accountHolder,
  'created_at': instance.createdAt.toIso8601String(),
  'nama_lengkap': instance.namaPemohon,
};
