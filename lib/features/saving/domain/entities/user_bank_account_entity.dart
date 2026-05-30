import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bank_account_entity.freezed.dart';
part 'user_bank_account_entity.g.dart';

@freezed
class UserBankAccountEntity with _$UserBankAccountEntity {
  const factory UserBankAccountEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'bank_code') required String bankCode,
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_holder') required String accountHolder,
    @JsonKey(name: 'is_primary') @Default(true) bool isPrimary,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserBankAccountEntity;

  factory UserBankAccountEntity.fromJson(Map<String, dynamic> json) =>
      _$UserBankAccountEntityFromJson(json);
}
