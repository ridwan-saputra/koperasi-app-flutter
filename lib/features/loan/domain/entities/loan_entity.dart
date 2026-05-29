import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_entity.freezed.dart';
part 'loan_entity.g.dart';

@freezed
class LoanEntity with _$LoanEntity {
  const factory LoanEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'nominal_pokok') required double nominalPokok,
    @JsonKey(name: 'tenor_bulan') required int tenorBulan,
    @JsonKey(name: 'bunga_persen') required double bungaPersen,
    @JsonKey(name: 'biaya_admin') required double biayaAdmin,
    @JsonKey(name: 'total_bayar') required double totalBayar,
    @JsonKey(name: 'cicilan_per_bulan') required double cicilanPerBulan,
    @JsonKey(name: 'agunan_detail') String? agunanDetail, 
    @JsonKey(name: 'alamat_tinggal') required String alamatTinggal,
    required String pekerjaan,
    @JsonKey(name: 'total_pendapatan') required double totalPendapatan,
    @JsonKey(name: 'rekening_tujuan') required String rekeningTujuan,
    @JsonKey(name: 'ktp_image_path') required String ktpImagePath,
    @JsonKey(name: 'selfie_image_path') required String selfieImagePath,
    required String status, 
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Field tambahan untuk menampung nama dari tabel users (INNER JOIN)
    @JsonKey(name: 'nama_lengkap') String? namaPeminjam, 
  }) = _LoanEntity;

  factory LoanEntity.fromJson(Map<String, dynamic> json) => _$LoanEntityFromJson(json);
}