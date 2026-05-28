import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // Contoh: 'DEPOSIT'
    required double nominal,
    required String status, // Contoh: 'SUCCESS' atau 'PENDING'
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);
}