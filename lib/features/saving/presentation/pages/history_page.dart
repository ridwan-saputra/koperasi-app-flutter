import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/saving_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Harap login terlebih dahulu')));
    }

    final historyAsync = ref.watch(historyProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Terjadi kesalahan: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat transaksi.', style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final trx = transactions[index];
              final dateFormatted = DateFormat('dd MMM yyyy, HH:mm').format(trx.createdAt);
              final isDeposit = trx.type == 'DEPOSIT';
              final isCicilan = trx.type == 'CICILAN';
              final isWithdraw = trx.type == 'WITHDRAW';

              String title;
              if (isDeposit) {
                title = 'Setor Tunai';
              } else if (isCicilan) {
                title = 'Bayar Cicilan';
              } else if (isWithdraw) {
                title = 'Tarik ke Bank';
              } else {
                title = trx.type;
              }

              final buffer = StringBuffer(dateFormatted);
              if (isCicilan && trx.loanId != null) {
                buffer.write('\nPinjaman: ${trx.loanId!.substring(0, 8)}...');
              }
              if (isWithdraw && trx.bankName != null) {
                buffer.write('\n${trx.bankName} • ${trx.accountNumber}');
              }
              if (isWithdraw && trx.status != 'SUCCESS') {
                buffer.write('\nStatus: ${trx.status}');
              }

              final isCredit = isDeposit;
              Color amountColor = isCredit ? Colors.green : Colors.red;
              if (isWithdraw && trx.status == 'PENDING') {
                amountColor = Colors.orange;
              } else if (isWithdraw && trx.status == 'REJECTED') {
                amountColor = Colors.grey;
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCredit
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    child: Icon(
                      isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(buffer.toString()),
                  isThreeLine: true,
                  trailing: Text(
                    '${isCredit ? '+' : '-'} ${CurrencyFormatter.format(trx.nominal)}',
                    style: TextStyle(
                      color: amountColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
