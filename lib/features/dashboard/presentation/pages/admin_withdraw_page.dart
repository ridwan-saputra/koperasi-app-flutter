import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../saving/domain/entities/transaction_entity.dart';
import '../../../saving/presentation/providers/withdraw_provider.dart';

class AdminWithdrawPage extends ConsumerWidget {
  const AdminWithdrawPage({super.key});

  void _showActionDialog(
    BuildContext context,
    WidgetRef ref,
    TransactionEntity withdraw,
    bool isApprove,
  ) {
    final actionText = isApprove ? 'Setujui' : 'Tolak';
    final color = isApprove ? Colors.green : Colors.redAccent;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Konfirmasi $actionText'),
        content: Text(
          'Anda yakin ingin $actionText penarikan ${CurrencyFormatter.format(withdraw.nominal)} '
          'ke ${withdraw.bankName} - ${withdraw.accountNumber}?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref.read(adminWithdrawNotifierProvider.notifier).processWithdraw(
                    transactionId: withdraw.id,
                    userId: withdraw.userId,
                    isApprove: isApprove,
                  );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Penarikan berhasil di-${isApprove ? 'setujui' : 'tolak'}'),
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
    final pendingAsync = ref.watch(pendingWithdrawalsProvider);
    final isProcessing = ref.watch(adminWithdrawNotifierProvider).isLoading;

    ref.listen<AsyncValue<void>>(adminWithdrawNotifierProvider, (previous, next) {
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
        title: const Text('Antrean Penarikan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          pendingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Terjadi kesalahan: $error')),
            data: (withdrawals) {
              if (withdrawals.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada pengajuan penarikan pending.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: withdrawals.length,
                itemBuilder: (context, index) {
                  final w = withdrawals[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.namaPemohon ?? 'Anggota',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${w.id.substring(0, 8)}...',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const Divider(height: 24),
                          Text(
                            CurrencyFormatter.format(w.nominal),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text('Bank: ${w.bankName ?? '-'}'),
                          Text('No. Rekening: ${w.accountNumber ?? '-'}'),
                          Text('Atas Nama: ${w.accountHolder ?? '-'}'),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _showActionDialog(context, ref, w, false),
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
                                  onPressed: () => _showActionDialog(context, ref, w, true),
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
