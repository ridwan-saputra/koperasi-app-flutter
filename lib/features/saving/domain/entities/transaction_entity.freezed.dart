// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) {
  return _TransactionEntity.fromJson(json);
}

/// @nodoc
mixin _$TransactionEntity {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'DEPOSIT' | 'CICILAN' | 'WITHDRAW'
  double get nominal => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'SUCCESS' | 'PENDING' | 'REJECTED'
  @JsonKey(name: 'loan_id')
  String? get loanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_code')
  String? get bankCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String? get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_holder')
  String? get accountHolder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'nama_lengkap')
  String? get namaPemohon => throw _privateConstructorUsedError;

  /// Serializes this TransactionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
    TransactionEntity value,
    $Res Function(TransactionEntity) then,
  ) = _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String type,
    double nominal,
    String status,
    @JsonKey(name: 'loan_id') String? loanId,
    @JsonKey(name: 'bank_code') String? bankCode,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'account_holder') String? accountHolder,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'nama_lengkap') String? namaPemohon,
  });
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? nominal = null,
    Object? status = null,
    Object? loanId = freezed,
    Object? bankCode = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolder = freezed,
    Object? createdAt = null,
    Object? namaPemohon = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            nominal: null == nominal
                ? _value.nominal
                : nominal // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            loanId: freezed == loanId
                ? _value.loanId
                : loanId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankCode: freezed == bankCode
                ? _value.bankCode
                : bankCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            bankName: freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountNumber: freezed == accountNumber
                ? _value.accountNumber
                : accountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountHolder: freezed == accountHolder
                ? _value.accountHolder
                : accountHolder // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            namaPemohon: freezed == namaPemohon
                ? _value.namaPemohon
                : namaPemohon // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionEntityImplCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$TransactionEntityImplCopyWith(
    _$TransactionEntityImpl value,
    $Res Function(_$TransactionEntityImpl) then,
  ) = __$$TransactionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String type,
    double nominal,
    String status,
    @JsonKey(name: 'loan_id') String? loanId,
    @JsonKey(name: 'bank_code') String? bankCode,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'account_holder') String? accountHolder,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'nama_lengkap') String? namaPemohon,
  });
}

/// @nodoc
class __$$TransactionEntityImplCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$TransactionEntityImpl>
    implements _$$TransactionEntityImplCopyWith<$Res> {
  __$$TransactionEntityImplCopyWithImpl(
    _$TransactionEntityImpl _value,
    $Res Function(_$TransactionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? nominal = null,
    Object? status = null,
    Object? loanId = freezed,
    Object? bankCode = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolder = freezed,
    Object? createdAt = null,
    Object? namaPemohon = freezed,
  }) {
    return _then(
      _$TransactionEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        nominal: null == nominal
            ? _value.nominal
            : nominal // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        loanId: freezed == loanId
            ? _value.loanId
            : loanId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankCode: freezed == bankCode
            ? _value.bankCode
            : bankCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        bankName: freezed == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountNumber: freezed == accountNumber
            ? _value.accountNumber
            : accountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountHolder: freezed == accountHolder
            ? _value.accountHolder
            : accountHolder // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        namaPemohon: freezed == namaPemohon
            ? _value.namaPemohon
            : namaPemohon // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionEntityImpl implements _TransactionEntity {
  const _$TransactionEntityImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.type,
    required this.nominal,
    required this.status,
    @JsonKey(name: 'loan_id') this.loanId,
    @JsonKey(name: 'bank_code') this.bankCode,
    @JsonKey(name: 'bank_name') this.bankName,
    @JsonKey(name: 'account_number') this.accountNumber,
    @JsonKey(name: 'account_holder') this.accountHolder,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'nama_lengkap') this.namaPemohon,
  });

  factory _$TransactionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionEntityImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String type;
  // 'DEPOSIT' | 'CICILAN' | 'WITHDRAW'
  @override
  final double nominal;
  @override
  final String status;
  // 'SUCCESS' | 'PENDING' | 'REJECTED'
  @override
  @JsonKey(name: 'loan_id')
  final String? loanId;
  @override
  @JsonKey(name: 'bank_code')
  final String? bankCode;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'account_number')
  final String? accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  final String? accountHolder;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'nama_lengkap')
  final String? namaPemohon;

  @override
  String toString() {
    return 'TransactionEntity(id: $id, userId: $userId, type: $type, nominal: $nominal, status: $status, loanId: $loanId, bankCode: $bankCode, bankName: $bankName, accountNumber: $accountNumber, accountHolder: $accountHolder, createdAt: $createdAt, namaPemohon: $namaPemohon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nominal, nominal) || other.nominal == nominal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.bankCode, bankCode) ||
                other.bankCode == bankCode) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.namaPemohon, namaPemohon) ||
                other.namaPemohon == namaPemohon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    nominal,
    status,
    loanId,
    bankCode,
    bankName,
    accountNumber,
    accountHolder,
    createdAt,
    namaPemohon,
  );

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      __$$TransactionEntityImplCopyWithImpl<_$TransactionEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionEntityImplToJson(this);
  }
}

abstract class _TransactionEntity implements TransactionEntity {
  const factory _TransactionEntity({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String type,
    required final double nominal,
    required final String status,
    @JsonKey(name: 'loan_id') final String? loanId,
    @JsonKey(name: 'bank_code') final String? bankCode,
    @JsonKey(name: 'bank_name') final String? bankName,
    @JsonKey(name: 'account_number') final String? accountNumber,
    @JsonKey(name: 'account_holder') final String? accountHolder,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'nama_lengkap') final String? namaPemohon,
  }) = _$TransactionEntityImpl;

  factory _TransactionEntity.fromJson(Map<String, dynamic> json) =
      _$TransactionEntityImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get type; // 'DEPOSIT' | 'CICILAN' | 'WITHDRAW'
  @override
  double get nominal;
  @override
  String get status; // 'SUCCESS' | 'PENDING' | 'REJECTED'
  @override
  @JsonKey(name: 'loan_id')
  String? get loanId;
  @override
  @JsonKey(name: 'bank_code')
  String? get bankCode;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'account_number')
  String? get accountNumber;
  @override
  @JsonKey(name: 'account_holder')
  String? get accountHolder;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'nama_lengkap')
  String? get namaPemohon;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
