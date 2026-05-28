import 'package:flutter/material.dart';
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

  Future<void> _handleDeposit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Ambil data user yang sedang aktif
      final user = ref.read(authNotifierProvider).value;
      
      if (user != null) {
        // Buat objek transaksi baru
        final newTransaction = TransactionEntity(
          id: const Uuid().v4(),
          userId: user.id,
          type: 'DEPOSIT',
          nominal: double.parse(_nominalController.text),
          status: 'SUCCESS', // Di sistem nyata, status awal biasanya PENDING
          createdAt: DateTime.now(),
        );

        // Eksekusi fungsi deposit di provider
        final success = await ref.read(balanceNotifierProvider.notifier).makeDeposit(newTransaction);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Simpanan berhasil ditambahkan!'), backgroundColor: Colors.green),
          );
          // Kembali ke halaman sebelumnya (Dashboard)
          context.pop();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaksi gagal diproses.'), backgroundColor: Colors.redAccent),
          );
        }
      }
      
      setState(() => _isLoading = false);
    }
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
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nominal tidak boleh kosong';
                  if (double.tryParse(value) == null) return 'Nominal harus berupa angka';
                  if (double.parse(value) < 10000) return 'Minimal setoran Rp 10.000';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleDeposit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}