import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/saving_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil data user yang sedang aktif
    final user = ref.watch(authNotifierProvider).value;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Harap login terlebih dahulu')));
    }

    // Pantau FutureProvider berdasarkan ID user
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
              // Format tanggal menjadi lebih rapi
              final dateFormatted = DateFormat('dd MMM yyyy, HH:mm').format(trx.createdAt);

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: trx.type == 'DEPOSIT' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    child: Icon(
                      trx.type == 'DEPOSIT' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: trx.type == 'DEPOSIT' ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    trx.type == 'DEPOSIT' ? 'Setor Tunai' : 'Tarik Tunai',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(dateFormatted),
                  trailing: Text(
                    '+ Rp ${trx.nominal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.green,
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