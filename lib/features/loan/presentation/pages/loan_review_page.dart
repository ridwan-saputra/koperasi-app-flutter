import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/loan_calculator.dart';
import '../providers/loan_draft_provider.dart';

class LoanReviewPage extends ConsumerStatefulWidget {
  const LoanReviewPage({super.key});

  @override
  ConsumerState<LoanReviewPage> createState() => _LoanReviewPageState();
}

class _LoanReviewPageState extends ConsumerState<LoanReviewPage> {
  bool _isAgreed = false;
  bool _isLoading = false;

  void _submitLoanRequest() async {
    setState(() => _isLoading = true);
    
    // TODO: Fungsi Insert ke SQLite & Repository akan dikerjakan di Tahap 3
    await Future.delayed(const Duration(seconds: 2)); // Simulasi loading sementara

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulasi: Pengajuan berhasil! Status PENDING.'), backgroundColor: Colors.green),
      );
      // Bersihkan draft dan kembali ke Dashboard
      ref.read(loanDraftProvider.notifier).state = null;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Membaca data sementara dari form sebelumnya
    final draftData = ref.watch(loanDraftProvider);

    if (draftData == null) {
      return const Scaffold(body: Center(child: Text('Data pengajuan tidak ditemukan.')));
    }

    final double nominal = draftData['nominal'];
    final int tenor = draftData['tenor'];

    // Memanggil Domain Logic (Clean Architecture)
    final totalBunga = LoanCalculator.hitungTotalBunga(nominal, tenor);
    final totalBayar = LoanCalculator.hitungTotalBayar(nominal, tenor);
    final cicilan = LoanCalculator.hitungCicilanPerBulan(nominal, tenor);

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
          
          // Checkbox Persetujuan
          CheckboxListTile(
            value: _isAgreed,
            activeColor: Colors.blueAccent,
            title: const Text(
              'Saya menyetujui seluruh syarat, ketentuan, serta rincian biaya Koperasi yang tertera di atas.',
              style: TextStyle(fontSize: 14),
            ),
            onChanged: (value) => setState(() => _isAgreed = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: (_isAgreed && !_isLoading) ? _submitLoanRequest : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: _isLoading 
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