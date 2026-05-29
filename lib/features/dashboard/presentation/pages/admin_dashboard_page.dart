import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../loan/presentation/providers/admin_loan_provider.dart';
import '../../../loan/domain/entities/loan_entity.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  void _showActionDialog(BuildContext context, WidgetRef ref, LoanEntity loan, String adminId, bool isApprove) {
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
            Text('Anda yakin ingin men$actionText pinjaman sebesar Rp ${loan.nominalPokok.toStringAsFixed(0)} ini?'),
            const SizedBox(height: 16),
            TextField(
              controller: remarksController,
              decoration: const InputDecoration(labelText: 'Catatan Admin (Opsional)', border: OutlineInputBorder()),
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
                remarks: remarksController.text.isEmpty ? 'Diproses oleh Admin' : remarksController.text,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pinjaman berhasil di-$status'), backgroundColor: Colors.blueAccent),
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
    final adminState = ref.watch(authNotifierProvider).value;
    final isProcessing = ref.watch(adminActionProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Baru untuk melihat Daftar Anggota
          IconButton(
            icon: const Icon(Icons.people_alt_rounded),
            tooltip: 'Daftar Anggota',
            onPressed: () => context.push('/admin-members'), 
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          pendingLoansAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
            data: (loans) {
              if (loans.isEmpty) {
                return const Center(child: Text('Tidak ada antrean pengajuan pinjaman.', style: TextStyle(fontSize: 16, color: Colors.grey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ID: ${loan.id.substring(0, 8)}...', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                                child: Text(loan.status, style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Text('Pengajuan: Rp ${loan.nominalPokok.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Tenor: ${loan.tenorBulan} Bulan'),
                          Text('Pekerjaan: ${loan.pekerjaan}'),
                          Text('Pendapatan: Rp ${loan.totalPendapatan.toStringAsFixed(0)}/bulan'),
                          if (loan.agunanDetail != null) ...[
                            const SizedBox(height: 8),
                            Text('Agunan: ${loan.agunanDetail}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _showActionDialog(context, ref, loan, adminState!.id, false),
                                icon: const Icon(Icons.close, color: Colors.red),
                                label: const Text('Tolak', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => _showActionDialog(context, ref, loan, adminState!.id, true),
                                icon: const Icon(Icons.check),
                                label: const Text('Setujui'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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