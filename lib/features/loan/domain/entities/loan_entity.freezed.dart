// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoanEntity _$LoanEntityFromJson(Map<String, dynamic> json) {
  return _LoanEntity.fromJson(json);
}

/// @nodoc
mixin _$LoanEntity {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'nominal_pokok')
  double get nominalPokok => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenor_bulan')
  int get tenorBulan => throw _privateConstructorUsedError;
  @JsonKey(name: 'bunga_persen')
  double get bungaPersen => throw _privateConstructorUsedError;
  @JsonKey(name: 'biaya_admin')
  double get biayaAdmin => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_bayar')
  double get totalBayar => throw _privateConstructorUsedError;
  @JsonKey(name: 'cicilan_per_bulan')
  double get cicilanPerBulan => throw _privateConstructorUsedError;
  @JsonKey(name: 'agunan_detail')
  String? get agunanDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'agunan_image_path')
  String? get agunanImagePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'alamat_tinggal')
  String get alamatTinggal => throw _privateConstructorUsedError;
  String get pekerjaan => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pendapatan')
  double get totalPendapatan => throw _privateConstructorUsedError; // Field rekening_tujuan sudah resmi dihapus dari sistem
  @JsonKey(name: 'ktp_image_path')
  String get ktpImagePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'selfie_image_path')
  String get selfieImagePath => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'nama_lengkap')
  String? get namaPeminjam => throw _privateConstructorUsedError;

  /// Serializes this LoanEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanEntityCopyWith<LoanEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanEntityCopyWith<$Res> {
  factory $LoanEntityCopyWith(
    LoanEntity value,
    $Res Function(LoanEntity) then,
  ) = _$LoanEntityCopyWithImpl<$Res, LoanEntity>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'nominal_pokok') double nominalPokok,
    @JsonKey(name: 'tenor_bulan') int tenorBulan,
    @JsonKey(name: 'bunga_persen') double bungaPersen,
    @JsonKey(name: 'biaya_admin') double biayaAdmin,
    @JsonKey(name: 'total_bayar') double totalBayar,
    @JsonKey(name: 'cicilan_per_bulan') double cicilanPerBulan,
    @JsonKey(name: 'agunan_detail') String? agunanDetail,
    @JsonKey(name: 'agunan_image_path') String? agunanImagePath,
    @JsonKey(name: 'alamat_tinggal') String alamatTinggal,
    String pekerjaan,
    @JsonKey(name: 'total_pendapatan') double totalPendapatan,
    @JsonKey(name: 'ktp_image_path') String ktpImagePath,
    @JsonKey(name: 'selfie_image_path') String selfieImagePath,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'nama_lengkap') String? namaPeminjam,
  });
}

/// @nodoc
class _$LoanEntityCopyWithImpl<$Res, $Val extends LoanEntity>
    implements $LoanEntityCopyWith<$Res> {
  _$LoanEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nominalPokok = null,
    Object? tenorBulan = null,
    Object? bungaPersen = null,
    Object? biayaAdmin = null,
    Object? totalBayar = null,
    Object? cicilanPerBulan = null,
    Object? agunanDetail = freezed,
    Object? agunanImagePath = freezed,
    Object? alamatTinggal = null,
    Object? pekerjaan = null,
    Object? totalPendapatan = null,
    Object? ktpImagePath = null,
    Object? selfieImagePath = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? namaPeminjam = freezed,
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
            nominalPokok: null == nominalPokok
                ? _value.nominalPokok
                : nominalPokok // ignore: cast_nullable_to_non_nullable
                      as double,
            tenorBulan: null == tenorBulan
                ? _value.tenorBulan
                : tenorBulan // ignore: cast_nullable_to_non_nullable
                      as int,
            bungaPersen: null == bungaPersen
                ? _value.bungaPersen
                : bungaPersen // ignore: cast_nullable_to_non_nullable
                      as double,
            biayaAdmin: null == biayaAdmin
                ? _value.biayaAdmin
                : biayaAdmin // ignore: cast_nullable_to_non_nullable
                      as double,
            totalBayar: null == totalBayar
                ? _value.totalBayar
                : totalBayar // ignore: cast_nullable_to_non_nullable
                      as double,
            cicilanPerBulan: null == cicilanPerBulan
                ? _value.cicilanPerBulan
                : cicilanPerBulan // ignore: cast_nullable_to_non_nullable
                      as double,
            agunanDetail: freezed == agunanDetail
                ? _value.agunanDetail
                : agunanDetail // ignore: cast_nullable_to_non_nullable
                      as String?,
            agunanImagePath: freezed == agunanImagePath
                ? _value.agunanImagePath
                : agunanImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            alamatTinggal: null == alamatTinggal
                ? _value.alamatTinggal
                : alamatTinggal // ignore: cast_nullable_to_non_nullable
                      as String,
            pekerjaan: null == pekerjaan
                ? _value.pekerjaan
                : pekerjaan // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPendapatan: null == totalPendapatan
                ? _value.totalPendapatan
                : totalPendapatan // ignore: cast_nullable_to_non_nullable
                      as double,
            ktpImagePath: null == ktpImagePath
                ? _value.ktpImagePath
                : ktpImagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            selfieImagePath: null == selfieImagePath
                ? _value.selfieImagePath
                : selfieImagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            namaPeminjam: freezed == namaPeminjam
                ? _value.namaPeminjam
                : namaPeminjam // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanEntityImplCopyWith<$Res>
    implements $LoanEntityCopyWith<$Res> {
  factory _$$LoanEntityImplCopyWith(
    _$LoanEntityImpl value,
    $Res Function(_$LoanEntityImpl) then,
  ) = __$$LoanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'nominal_pokok') double nominalPokok,
    @JsonKey(name: 'tenor_bulan') int tenorBulan,
    @JsonKey(name: 'bunga_persen') double bungaPersen,
    @JsonKey(name: 'biaya_admin') double biayaAdmin,
    @JsonKey(name: 'total_bayar') double totalBayar,
    @JsonKey(name: 'cicilan_per_bulan') double cicilanPerBulan,
    @JsonKey(name: 'agunan_detail') String? agunanDetail,
    @JsonKey(name: 'agunan_image_path') String? agunanImagePath,
    @JsonKey(name: 'alamat_tinggal') String alamatTinggal,
    String pekerjaan,
    @JsonKey(name: 'total_pendapatan') double totalPendapatan,
    @JsonKey(name: 'ktp_image_path') String ktpImagePath,
    @JsonKey(name: 'selfie_image_path') String selfieImagePath,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'nama_lengkap') String? namaPeminjam,
  });
}

/// @nodoc
class __$$LoanEntityImplCopyWithImpl<$Res>
    extends _$LoanEntityCopyWithImpl<$Res, _$LoanEntityImpl>
    implements _$$LoanEntityImplCopyWith<$Res> {
  __$$LoanEntityImplCopyWithImpl(
    _$LoanEntityImpl _value,
    $Res Function(_$LoanEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nominalPokok = null,
    Object? tenorBulan = null,
    Object? bungaPersen = null,
    Object? biayaAdmin = null,
    Object? totalBayar = null,
    Object? cicilanPerBulan = null,
    Object? agunanDetail = freezed,
    Object? agunanImagePath = freezed,
    Object? alamatTinggal = null,
    Object? pekerjaan = null,
    Object? totalPendapatan = null,
    Object? ktpImagePath = null,
    Object? selfieImagePath = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? namaPeminjam = freezed,
  }) {
    return _then(
      _$LoanEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        nominalPokok: null == nominalPokok
            ? _value.nominalPokok
            : nominalPokok // ignore: cast_nullable_to_non_nullable
                  as double,
        tenorBulan: null == tenorBulan
            ? _value.tenorBulan
            : tenorBulan // ignore: cast_nullable_to_non_nullable
                  as int,
        bungaPersen: null == bungaPersen
            ? _value.bungaPersen
            : bungaPersen // ignore: cast_nullable_to_non_nullable
                  as double,
        biayaAdmin: null == biayaAdmin
            ? _value.biayaAdmin
            : biayaAdmin // ignore: cast_nullable_to_non_nullable
                  as double,
        totalBayar: null == totalBayar
            ? _value.totalBayar
            : totalBayar // ignore: cast_nullable_to_non_nullable
                  as double,
        cicilanPerBulan: null == cicilanPerBulan
            ? _value.cicilanPerBulan
            : cicilanPerBulan // ignore: cast_nullable_to_non_nullable
                  as double,
        agunanDetail: freezed == agunanDetail
            ? _value.agunanDetail
            : agunanDetail // ignore: cast_nullable_to_non_nullable
                  as String?,
        agunanImagePath: freezed == agunanImagePath
            ? _value.agunanImagePath
            : agunanImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        alamatTinggal: null == alamatTinggal
            ? _value.alamatTinggal
            : alamatTinggal // ignore: cast_nullable_to_non_nullable
                  as String,
        pekerjaan: null == pekerjaan
            ? _value.pekerjaan
            : pekerjaan // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPendapatan: null == totalPendapatan
            ? _value.totalPendapatan
            : totalPendapatan // ignore: cast_nullable_to_non_nullable
                  as double,
        ktpImagePath: null == ktpImagePath
            ? _value.ktpImagePath
            : ktpImagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        selfieImagePath: null == selfieImagePath
            ? _value.selfieImagePath
            : selfieImagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        namaPeminjam: freezed == namaPeminjam
            ? _value.namaPeminjam
            : namaPeminjam // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanEntityImpl implements _LoanEntity {
  const _$LoanEntityImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'nominal_pokok') required this.nominalPokok,
    @JsonKey(name: 'tenor_bulan') required this.tenorBulan,
    @JsonKey(name: 'bunga_persen') required this.bungaPersen,
    @JsonKey(name: 'biaya_admin') required this.biayaAdmin,
    @JsonKey(name: 'total_bayar') required this.totalBayar,
    @JsonKey(name: 'cicilan_per_bulan') required this.cicilanPerBulan,
    @JsonKey(name: 'agunan_detail') this.agunanDetail,
    @JsonKey(name: 'agunan_image_path') this.agunanImagePath,
    @JsonKey(name: 'alamat_tinggal') required this.alamatTinggal,
    required this.pekerjaan,
    @JsonKey(name: 'total_pendapatan') required this.totalPendapatan,
    @JsonKey(name: 'ktp_image_path') required this.ktpImagePath,
    @JsonKey(name: 'selfie_image_path') required this.selfieImagePath,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'nama_lengkap') this.namaPeminjam,
  });

  factory _$LoanEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanEntityImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'nominal_pokok')
  final double nominalPokok;
  @override
  @JsonKey(name: 'tenor_bulan')
  final int tenorBulan;
  @override
  @JsonKey(name: 'bunga_persen')
  final double bungaPersen;
  @override
  @JsonKey(name: 'biaya_admin')
  final double biayaAdmin;
  @override
  @JsonKey(name: 'total_bayar')
  final double totalBayar;
  @override
  @JsonKey(name: 'cicilan_per_bulan')
  final double cicilanPerBulan;
  @override
  @JsonKey(name: 'agunan_detail')
  final String? agunanDetail;
  @override
  @JsonKey(name: 'agunan_image_path')
  final String? agunanImagePath;
  @override
  @JsonKey(name: 'alamat_tinggal')
  final String alamatTinggal;
  @override
  final String pekerjaan;
  @override
  @JsonKey(name: 'total_pendapatan')
  final double totalPendapatan;
  // Field rekening_tujuan sudah resmi dihapus dari sistem
  @override
  @JsonKey(name: 'ktp_image_path')
  final String ktpImagePath;
  @override
  @JsonKey(name: 'selfie_image_path')
  final String selfieImagePath;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'nama_lengkap')
  final String? namaPeminjam;

  @override
  String toString() {
    return 'LoanEntity(id: $id, userId: $userId, nominalPokok: $nominalPokok, tenorBulan: $tenorBulan, bungaPersen: $bungaPersen, biayaAdmin: $biayaAdmin, totalBayar: $totalBayar, cicilanPerBulan: $cicilanPerBulan, agunanDetail: $agunanDetail, agunanImagePath: $agunanImagePath, alamatTinggal: $alamatTinggal, pekerjaan: $pekerjaan, totalPendapatan: $totalPendapatan, ktpImagePath: $ktpImagePath, selfieImagePath: $selfieImagePath, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, namaPeminjam: $namaPeminjam)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nominalPokok, nominalPokok) ||
                other.nominalPokok == nominalPokok) &&
            (identical(other.tenorBulan, tenorBulan) ||
                other.tenorBulan == tenorBulan) &&
            (identical(other.bungaPersen, bungaPersen) ||
                other.bungaPersen == bungaPersen) &&
            (identical(other.biayaAdmin, biayaAdmin) ||
                other.biayaAdmin == biayaAdmin) &&
            (identical(other.totalBayar, totalBayar) ||
                other.totalBayar == totalBayar) &&
            (identical(other.cicilanPerBulan, cicilanPerBulan) ||
                other.cicilanPerBulan == cicilanPerBulan) &&
            (identical(other.agunanDetail, agunanDetail) ||
                other.agunanDetail == agunanDetail) &&
            (identical(other.agunanImagePath, agunanImagePath) ||
                other.agunanImagePath == agunanImagePath) &&
            (identical(other.alamatTinggal, alamatTinggal) ||
                other.alamatTinggal == alamatTinggal) &&
            (identical(other.pekerjaan, pekerjaan) ||
                other.pekerjaan == pekerjaan) &&
            (identical(other.totalPendapatan, totalPendapatan) ||
                other.totalPendapatan == totalPendapatan) &&
            (identical(other.ktpImagePath, ktpImagePath) ||
                other.ktpImagePath == ktpImagePath) &&
            (identical(other.selfieImagePath, selfieImagePath) ||
                other.selfieImagePath == selfieImagePath) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.namaPeminjam, namaPeminjam) ||
                other.namaPeminjam == namaPeminjam));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    nominalPokok,
    tenorBulan,
    bungaPersen,
    biayaAdmin,
    totalBayar,
    cicilanPerBulan,
    agunanDetail,
    agunanImagePath,
    alamatTinggal,
    pekerjaan,
    totalPendapatan,
    ktpImagePath,
    selfieImagePath,
    status,
    createdAt,
    updatedAt,
    namaPeminjam,
  ]);

  /// Create a copy of LoanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanEntityImplCopyWith<_$LoanEntityImpl> get copyWith =>
      __$$LoanEntityImplCopyWithImpl<_$LoanEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanEntityImplToJson(this);
  }
}

abstract class _LoanEntity implements LoanEntity {
  const factory _LoanEntity({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'nominal_pokok') required final double nominalPokok,
    @JsonKey(name: 'tenor_bulan') required final int tenorBulan,
    @JsonKey(name: 'bunga_persen') required final double bungaPersen,
    @JsonKey(name: 'biaya_admin') required final double biayaAdmin,
    @JsonKey(name: 'total_bayar') required final double totalBayar,
    @JsonKey(name: 'cicilan_per_bulan') required final double cicilanPerBulan,
    @JsonKey(name: 'agunan_detail') final String? agunanDetail,
    @JsonKey(name: 'agunan_image_path') final String? agunanImagePath,
    @JsonKey(name: 'alamat_tinggal') required final String alamatTinggal,
    required final String pekerjaan,
    @JsonKey(name: 'total_pendapatan') required final double totalPendapatan,
    @JsonKey(name: 'ktp_image_path') required final String ktpImagePath,
    @JsonKey(name: 'selfie_image_path') required final String selfieImagePath,
    required final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    @JsonKey(name: 'nama_lengkap') final String? namaPeminjam,
  }) = _$LoanEntityImpl;

  factory _LoanEntity.fromJson(Map<String, dynamic> json) =
      _$LoanEntityImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'nominal_pokok')
  double get nominalPokok;
  @override
  @JsonKey(name: 'tenor_bulan')
  int get tenorBulan;
  @override
  @JsonKey(name: 'bunga_persen')
  double get bungaPersen;
  @override
  @JsonKey(name: 'biaya_admin')
  double get biayaAdmin;
  @override
  @JsonKey(name: 'total_bayar')
  double get totalBayar;
  @override
  @JsonKey(name: 'cicilan_per_bulan')
  double get cicilanPerBulan;
  @override
  @JsonKey(name: 'agunan_detail')
  String? get agunanDetail;
  @override
  @JsonKey(name: 'agunan_image_path')
  String? get agunanImagePath;
  @override
  @JsonKey(name: 'alamat_tinggal')
  String get alamatTinggal;
  @override
  String get pekerjaan;
  @override
  @JsonKey(name: 'total_pendapatan')
  double get totalPendapatan; // Field rekening_tujuan sudah resmi dihapus dari sistem
  @override
  @JsonKey(name: 'ktp_image_path')
  String get ktpImagePath;
  @override
  @JsonKey(name: 'selfie_image_path')
  String get selfieImagePath;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'nama_lengkap')
  String? get namaPeminjam;

  /// Create a copy of LoanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanEntityImplCopyWith<_$LoanEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
