import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // 'DEPOSIT' | 'CICILAN'
    required double nominal,
    required String status, // 'SUCCESS' | 'PENDING'
    @JsonKey(name: 'loan_id') String? loanId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);
}