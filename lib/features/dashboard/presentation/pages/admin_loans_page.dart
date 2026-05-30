import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../loan/domain/entities/loan_entity.dart';
import '../../../loan/presentation/providers/admin_loan_provider.dart';

class AdminLoansPage extends ConsumerWidget {
  const AdminLoansPage({super.key});

  void _showVerificationDialog(BuildContext context, LoanEntity loan) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          'Verifikasi Dokumen: ${loan.namaPeminjam ?? "Anggota"}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Foto KTP Asli',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                _buildImageContainer(loan.ktpImagePath),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  '2. Foto Selfie memegang KTP',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                _buildImageContainer(loan.selfieImagePath),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Widget _buildImageContainer(String path) {
    if (path.isNotEmpty && File(path).existsSync()) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(File(path), fit: BoxFit.contain),
        ),
      );
    }
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'File gambar tidak ditemukan\ndi perangkat ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(
    BuildContext context,
    WidgetRef ref,
    LoanEntity loan,
    String adminId,
    bool isApprove,
  ) {
    final remarksController = TextEditingController();
    final actionText = isApprove ? 'Setujui' : 'Tolak';
    final status = isApprove ? 'APPROVED' : 'REJECTED';
    final color = isApprove ? Colors.green : Colors.redAccent;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi $actionText'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Anda yakin ingin men$actionText pinjaman sebesar '
              '${CurrencyFormatter.format(loan.nominalPokok)} ini?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: 'Catatan Admin (Opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminActionProvider.notifier).processLoan(
                    loanId: loan.id,
                    adminId: adminId,
                    status: status,
                    remarks: remarksController.text.isEmpty
                        ? 'Diproses oleh Admin'
                        : remarksController.text,
                  );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pinjaman berhasil di-$status'),
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }
            },
            child: Text(actionText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingLoansAsync = ref.watch(pendingLoansProvider);
    final admin = ref.watch(authNotifierProvider).value;
    final isProcessing = ref.watch(adminActionProvider).isLoading;

    ref.listen<AsyncValue<void>>(adminActionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrean Pinjaman', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          pendingLoansAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Terjadi kesalahan: $error')),
            data: (loans) {
              if (loans.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada antrean pengajuan pinjaman.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(pendingLoansProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ID: ${loan.id.substring(0, 8)}...',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    loan.status,
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              loan.namaPeminjam ?? 'Nama Tidak Diketahui',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                            const Divider(height: 20),
                            Text(
                              'Pengajuan: ${CurrencyFormatter.format(loan.nominalPokok)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Tenor: ${loan.tenorBulan} Bulan'),
                            Text('Pekerjaan: ${loan.pekerjaan}'),
                            Text(
                              'Pendapatan: ${CurrencyFormatter.format(loan.totalPendapatan)}/bulan',
                            ),
                            if (loan.agunanDetail != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Agunan: ${loan.agunanDetail}',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () => _showVerificationDialog(context, loan),
                                icon: const Icon(Icons.fact_check_rounded, color: Colors.blue),
                                label: const Text(
                                  'Verifikasi Dokumen',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: admin == null
                                        ? null
                                        : () => _showActionDialog(
                                              context,
                                              ref,
                                              loan,
                                              admin.id,
                                              false,
                                            ),
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    label: const Text('Tolak', style: TextStyle(color: Colors.red)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: admin == null
                                        ? null
                                        : () => _showActionDialog(
                                              context,
                                              ref,
                                              loan,
                                              admin.id,
                                              true,
                                            ),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Setujui'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
