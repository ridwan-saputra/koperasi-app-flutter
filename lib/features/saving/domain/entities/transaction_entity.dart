import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // 'DEPOSIT' | 'CICILAN' | 'WITHDRAW'
    required double nominal,
    required String status, // 'SUCCESS' | 'PENDING' | 'REJECTED'
    @JsonKey(name: 'loan_id') String? loanId,
    @JsonKey(name: 'bank_code') String? bankCode,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'account_holder') String? accountHolder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'nama_lengkap') String? namaPemohon,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);
}