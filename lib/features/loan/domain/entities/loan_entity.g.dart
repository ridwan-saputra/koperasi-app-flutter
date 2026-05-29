// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanEntityImpl _$$LoanEntityImplFromJson(Map<String, dynamic> json) =>
    _$LoanEntityImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nominalPokok: (json['nominal_pokok'] as num).toDouble(),
      tenorBulan: (json['tenor_bulan'] as num).toInt(),
      bungaPersen: (json['bunga_persen'] as num).toDouble(),
      biayaAdmin: (json['biaya_admin'] as num).toDouble(),
      totalBayar: (json['total_bayar'] as num).toDouble(),
      cicilanPerBulan: (json['cicilan_per_bulan'] as num).toDouble(),
      agunanDetail: json['agunan_detail'] as String?,
      alamatTinggal: json['alamat_tinggal'] as String,
      pekerjaan: json['pekerjaan'] as String,
      totalPendapatan: (json['total_pendapatan'] as num).toDouble(),
      ktpImagePath: json['ktp_image_path'] as String,
      selfieImagePath: json['selfie_image_path'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      namaPeminjam: json['nama_lengkap'] as String?,
    );

Map<String, dynamic> _$$LoanEntityImplToJson(_$LoanEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'nominal_pokok': instance.nominalPokok,
      'tenor_bulan': instance.tenorBulan,
      'bunga_persen': instance.bungaPersen,
      'biaya_admin': instance.biayaAdmin,
      'total_bayar': instance.totalBayar,
      'cicilan_per_bulan': instance.cicilanPerBulan,
      'agunan_detail': instance.agunanDetail,
      'alamat_tinggal': instance.alamatTinggal,
      'pekerjaan': instance.pekerjaan,
      'total_pendapatan': instance.totalPendapatan,
      'ktp_image_path': instance.ktpImagePath,
      'selfie_image_path': instance.selfieImagePath,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'nama_lengkap': instance.namaPeminjam,
    };
