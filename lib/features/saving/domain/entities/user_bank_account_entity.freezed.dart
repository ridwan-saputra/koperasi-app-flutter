// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bank_account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserBankAccountEntity _$UserBankAccountEntityFromJson(
  Map<String, dynamic> json,
) {
  return _UserBankAccountEntity.fromJson(json);
}

/// @nodoc
mixin _$UserBankAccountEntity {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_code')
  String get bankCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_holder')
  String get accountHolder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserBankAccountEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBankAccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBankAccountEntityCopyWith<UserBankAccountEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBankAccountEntityCopyWith<$Res> {
  factory $UserBankAccountEntityCopyWith(
    UserBankAccountEntity value,
    $Res Function(UserBankAccountEntity) then,
  ) = _$UserBankAccountEntityCopyWithImpl<$Res, UserBankAccountEntity>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'bank_code') String bankCode,
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
    @JsonKey(name: 'is_primary') bool isPrimary,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$UserBankAccountEntityCopyWithImpl<
  $Res,
  $Val extends UserBankAccountEntity
>
    implements $UserBankAccountEntityCopyWith<$Res> {
  _$UserBankAccountEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBankAccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bankCode = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? isPrimary = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            bankCode: null == bankCode
                ? _value.bankCode
                : bankCode // ignore: cast_nullable_to_non_nullable
                      as String,
            bankName: null == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String,
            accountNumber: null == accountNumber
                ? _value.accountNumber
                : accountNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            accountHolder: null == accountHolder
                ? _value.accountHolder
                : accountHolder // ignore: cast_nullable_to_non_nullable
                      as String,
            isPrimary: null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserBankAccountEntityImplCopyWith<$Res>
    implements $UserBankAccountEntityCopyWith<$Res> {
  factory _$$UserBankAccountEntityImplCopyWith(
    _$UserBankAccountEntityImpl value,
    $Res Function(_$UserBankAccountEntityImpl) then,
  ) = __$$UserBankAccountEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'bank_code') String bankCode,
    @JsonKey(name: 'bank_name') String bankName,
    @JsonKey(name: 'account_number') String accountNumber,
    @JsonKey(name: 'account_holder') String accountHolder,
    @JsonKey(name: 'is_primary') bool isPrimary,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$UserBankAccountEntityImplCopyWithImpl<$Res>
    extends
        _$UserBankAccountEntityCopyWithImpl<$Res, _$UserBankAccountEntityImpl>
    implements _$$UserBankAccountEntityImplCopyWith<$Res> {
  __$$UserBankAccountEntityImplCopyWithImpl(
    _$UserBankAccountEntityImpl _value,
    $Res Function(_$UserBankAccountEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserBankAccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bankCode = null,
    Object? bankName = null,
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? isPrimary = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$UserBankAccountEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        bankCode: null == bankCode
            ? _value.bankCode
            : bankCode // ignore: cast_nullable_to_non_nullable
                  as String,
        bankName: null == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String,
        accountNumber: null == accountNumber
            ? _value.accountNumber
            : accountNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        accountHolder: null == accountHolder
            ? _value.accountHolder
            : accountHolder // ignore: cast_nullable_to_non_nullable
                  as String,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBankAccountEntityImpl implements _UserBankAccountEntity {
  const _$UserBankAccountEntityImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'bank_code') required this.bankCode,
    @JsonKey(name: 'bank_name') required this.bankName,
    @JsonKey(name: 'account_number') required this.accountNumber,
    @JsonKey(name: 'account_holder') required this.accountHolder,
    @JsonKey(name: 'is_primary') this.isPrimary = true,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$UserBankAccountEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBankAccountEntityImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'bank_code')
  final String bankCode;
  @override
  @JsonKey(name: 'bank_name')
  final String bankName;
  @override
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  final String accountHolder;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserBankAccountEntity(id: $id, userId: $userId, bankCode: $bankCode, bankName: $bankName, accountNumber: $accountNumber, accountHolder: $accountHolder, isPrimary: $isPrimary, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBankAccountEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bankCode, bankCode) ||
                other.bankCode == bankCode) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    bankCode,
    bankName,
    accountNumber,
    accountHolder,
    isPrimary,
    createdAt,
  );

  /// Create a copy of UserBankAccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBankAccountEntityImplCopyWith<_$UserBankAccountEntityImpl>
  get copyWith =>
      __$$UserBankAccountEntityImplCopyWithImpl<_$UserBankAccountEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBankAccountEntityImplToJson(this);
  }
}

abstract class _UserBankAccountEntity implements UserBankAccountEntity {
  const factory _UserBankAccountEntity({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'bank_code') required final String bankCode,
    @JsonKey(name: 'bank_name') required final String bankName,
    @JsonKey(name: 'account_number') required final String accountNumber,
    @JsonKey(name: 'account_holder') required final String accountHolder,
    @JsonKey(name: 'is_primary') final bool isPrimary,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$UserBankAccountEntityImpl;

  factory _UserBankAccountEntity.fromJson(Map<String, dynamic> json) =
      _$UserBankAccountEntityImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'bank_code')
  String get bankCode;
  @override
  @JsonKey(name: 'bank_name')
  String get bankName;
  @override
  @JsonKey(name: 'account_number')
  String get accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  String get accountHolder;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of UserBankAccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBankAccountEntityImplCopyWith<_$UserBankAccountEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
