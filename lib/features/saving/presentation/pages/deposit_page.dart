import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/rupiah_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/saving_provider.dart';

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({super.key});

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  // Langkah 1: Validasi input dan munculkan QRIS
  void _handleLanjutPembayaran() {
    if (_formKey.currentState!.validate()) {
      // Sembunyikan keyboard
      FocusScope.of(context).unfocus(); 
      
      final nominal = CurrencyFormatter.parse(_nominalController.text)!;
      _showQrisSimulation(nominal);
    }
  }

  // Langkah 2: Proses penyimpanan ke SQLite setelah QRIS disetujui
  Future<void> _processDeposit(double nominal) async {
    setState(() => _isLoading = true);

    final user = ref.read(authNotifierProvider).value;
    
    if (user != null) {
      final newTransaction = TransactionEntity(
        id: const Uuid().v4(),
        userId: user.id,
        type: 'DEPOSIT',
        nominal: nominal,
        status: 'SUCCESS', // Karena ini disimulasikan berhasil
        createdAt: DateTime.now(),
      );

      final success = await ref.read(balanceNotifierProvider.notifier).makeDeposit(newTransaction);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pembayaran QRIS Berhasil! Saldo ditambahkan.'), backgroundColor: Colors.green),
        );
        // Kembali ke dashboard (menutup dialog QRIS dan halaman Deposit sekaligus)
        context.go('/user-dashboard');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi gagal diproses.'), backgroundColor: Colors.redAccent),
        );
      }
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // Tampilan UI Bottom Sheet untuk QRIS
  void _showQrisSimulation(double nominal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // Wajib menekan tombol untuk keluar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scan QRIS untuk Membayar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${CurrencyFormatter.format(nominal)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 24),
              // Simulasi gambar QR Code menggunakan Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  size: 200,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _processDeposit(nominal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simulasi Pembayaran Berhasil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Membatalkan pembayaran
                  Navigator.pop(context);
                },
                child: const Text('Batalkan', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setor Tunai'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Masukkan nominal uang yang ingin Anda simpan ke dalam Koperasi.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [RupiahInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Nominal',
                  hintText: 'Contoh: 100.000',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nominal tidak boleh kosong';
                  final nominal = CurrencyFormatter.parse(value);
                  if (nominal == null) return 'Nominal harus berupa angka';
                  if (nominal < 10000) {
                    return 'Minimal setoran ${CurrencyFormatter.format(10000)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleLanjutPembayaran,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Lanjut Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}