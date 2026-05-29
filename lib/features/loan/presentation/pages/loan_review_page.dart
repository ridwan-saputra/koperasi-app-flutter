import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/services/loan_calculator.dart';
import '../providers/loan_draft_provider.dart';
import '../providers/loan_provider.dart';

class LoanReviewPage extends ConsumerStatefulWidget {
  const LoanReviewPage({super.key});

  @override
  ConsumerState<LoanReviewPage> createState() => _LoanReviewPageState();
}

class _LoanReviewPageState extends ConsumerState<LoanReviewPage> {
  bool _isAgreed = false;

  void _submitLoanRequest(Map<String, dynamic> draftData, String userId) async {
    final double nominal = draftData['nominal'];
    final int tenor = draftData['tenor'];

    // Hitung rincian finansial murni dari Domain Logic
    // final totalBunga = LoanCalculator.hitungTotalBunga(nominal, tenor);
    final totalBayar = LoanCalculator.hitungTotalBayar(nominal, tenor);
    final cicilan = LoanCalculator.hitungCicilanPerBulan(nominal, tenor);

    // Bungkus semua data menjadi satu objek LoanEntity yang utuh
    final finalLoan = LoanEntity(
      id: const Uuid().v4(),
      userId: userId,
      nominalPokok: nominal,
      tenorBulan: tenor,
      bungaPersen: LoanCalculator.bungaPerBulan * 100, // Simpan dalam persen (2%)
      biayaAdmin: LoanCalculator.biayaAdminTetap,
      totalBayar: totalBayar,
      cicilanPerBulan: cicilan,
      agunanDetail: draftData['agunan'],
      alamatTinggal: draftData['alamat'],
      pekerjaan: draftData['pekerjaan'],
      totalPendapatan: draftData['pendapatan'],
      rekeningTujuan: draftData['rekening'],
      ktpImagePath: draftData['ktpPath'],
      selfieImagePath: draftData['selfiePath'],
      status: 'PENDING', // Status default saat pertama diajukan
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Eksekusi penyimpanan ke SQLite melalui Riverpod
    final success = await ref.read(loanNotifierProvider.notifier).submitLoan(finalLoan);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan pinjaman berhasil diajukan! Status: PENDING'),
          backgroundColor: Colors.green,
        ),
      );
      // Bersihkan draft data sementara agar aman
      ref.read(loanDraftProvider.notifier).state = null;
      // Kembali ke halaman utama (Dashboard)
      context.go('/user-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftData = ref.watch(loanDraftProvider);
    final user = ref.watch(authNotifierProvider).value;
    final loanState = ref.watch(loanNotifierProvider);

    if (draftData == null || user == null) {
      return const Scaffold(body: Center(child: Text('Data pengajuan tidak lengkap.')));
    }

    final double nominal = draftData['nominal'];
    final int tenor = draftData['tenor'];
    final totalBunga = LoanCalculator.hitungTotalBunga(nominal, tenor);
    final totalBayar = LoanCalculator.hitungTotalBayar(nominal, tenor);
    final cicilan = LoanCalculator.hitungCicilanPerBulan(nominal, tenor);

    // Dengarkan jika ada pesan error dari database untuk dimunculkan ke SnackBar
    ref.listen<AsyncValue>(loanNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Pinjaman')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Icon(Icons.receipt_long_rounded, size: 60, color: Colors.blueAccent),
          const SizedBox(height: 16),
          const Text(
            'Ringkasan Finansial',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          
          _buildDetailRow('Nominal Pinjaman', 'Rp ${nominal.toStringAsFixed(0)}'),
          _buildDetailRow('Tenor', '$tenor Bulan'),
          _buildDetailRow('Bunga (2%/Bulan)', 'Rp ${totalBunga.toStringAsFixed(0)}'),
          _buildDetailRow('Biaya Admin', 'Rp ${LoanCalculator.biayaAdminTetap.toStringAsFixed(0)}'),
          const Divider(height: 32, thickness: 2),
          
          _buildDetailRow('Total Harus Dibayar', 'Rp ${totalBayar.toStringAsFixed(0)}', isBold: true),
          
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Text('Estimasi Cicilan per Bulan', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Rp ${cicilan.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          
          CheckboxListTile(
            value: _isAgreed,
            activeColor: Colors.blueAccent,
            title: const Text(
              'Saya menyetujui seluruh syarat, ketentuan, serta rincian biaya Koperasi yang tertera di atas.',
              style: TextStyle(fontSize: 14),
            ),
            onChanged: loanState.isLoading ? null : (value) => setState(() => _isAgreed = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: (_isAgreed && !loanState.isLoading) ? () => _submitLoanRequest(draftData, user.id) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: loanState.isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Ajukan Pinjaman Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}