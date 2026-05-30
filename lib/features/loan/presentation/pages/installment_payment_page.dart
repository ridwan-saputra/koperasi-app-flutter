import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../saving/presentation/providers/saving_provider.dart';
import '../../domain/entities/loan_entity.dart';
import '../providers/installment_provider.dart';

class InstallmentPaymentPage extends ConsumerStatefulWidget {
  const InstallmentPaymentPage({super.key});

  @override
  ConsumerState<InstallmentPaymentPage> createState() => _InstallmentPaymentPageState();
}

class _InstallmentPaymentPageState extends ConsumerState<InstallmentPaymentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        ref.read(balanceNotifierProvider.notifier).fetchBalance(user.id);
      }
    });
  }

  String _formatRupiah(double number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(number);
  }

  void _confirmPayment(
    BuildContext context,
    LoanEntity loan,
    String userId,
    int paidCount,
  ) {
    final remaining = loan.tenorBulan - paidCount;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran Cicilan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pinjaman: ${_formatRupiah(loan.nominalPokok)}'),
            const SizedBox(height: 8),
            Text('Cicilan ke-${paidCount + 1} dari ${loan.tenorBulan}'),
            const SizedBox(height: 8),
            Text(
              'Nominal: ${_formatRupiah(loan.cicilanPerBulan)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Sisa cicilan setelah bayar: ${remaining - 1}',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref.read(installmentNotifierProvider.notifier).payInstallment(
                    loanId: loan.id,
                    userId: userId,
                  );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      paidCount + 1 >= loan.tenorBulan
                          ? 'Cicilan terakhir berhasil! Pinjaman lunas.'
                          : 'Pembayaran cicilan ke-${paidCount + 1} berhasil.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final isProcessing = ref.watch(installmentNotifierProvider).isLoading;
    final balanceState = ref.watch(balanceNotifierProvider);

    ref.listen<AsyncValue<void>>(installmentNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Harap login terlebih dahulu')),
      );
    }

    final activeLoansAsync = ref.watch(activeLoansProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bayar Cicilan'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Simpanan',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    balanceState.when(
                      data: (balance) => Text(
                        _formatRupiah(balance),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => const Text('Gagal memuat saldo'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pembayaran cicilan dipotong dari saldo simpanan Anda.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: activeLoansAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Terjadi kesalahan: $error')),
                  data: (loans) {
                    if (loans.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Tidak ada pinjaman aktif yang perlu dicicil.\nPinjaman harus berstatus disetujui (APPROVED).',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: loans.length,
                      itemBuilder: (context, index) {
                        final loan = loans[index];
                        final paidAsync = ref.watch(paidInstallmentCountProvider(loan.id));

                        return paidAsync.when(
                          loading: () => const Card(
                            child: ListTile(
                              leading: CircularProgressIndicator(),
                              title: Text('Memuat progres...'),
                            ),
                          ),
                          error: (error, _) => Card(
                            child: ListTile(title: Text('Error: $error')),
                          ),
                          data: (paidCount) => _LoanInstallmentCard(
                            loan: loan,
                            paidCount: paidCount,
                            formatRupiah: _formatRupiah,
                            onPay: () => _confirmPayment(context, loan, user.id, paidCount),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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

class _LoanInstallmentCard extends StatelessWidget {
  const _LoanInstallmentCard({
    required this.loan,
    required this.paidCount,
    required this.formatRupiah,
    required this.onPay,
  });

  final LoanEntity loan;
  final int paidCount;
  final String Function(double) formatRupiah;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final progress = paidCount / loan.tenorBulan;
    final sisa = loan.tenorBulan - paidCount;

    return Card(
      elevation: 3,
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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loan.status,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(loan.nominalPokok),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Cicilan/bulan: ${formatRupiah(loan.cicilanPerBulan)}'),
            Text('Tenor: ${loan.tenorBulan} bulan'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progres: $paidCount / ${loan.tenorBulan} cicilan',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('Sisa: $sisa'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPay,
                icon: const Icon(Icons.payments_rounded),
                label: Text('Bayar Cicilan ke-${paidCount + 1}'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
