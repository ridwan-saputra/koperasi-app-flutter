import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/constants/supported_banks.dart';
import '../../domain/entities/user_bank_account_entity.dart';
import '../providers/bank_account_provider.dart';

class BankAccountPage extends ConsumerStatefulWidget {
  const BankAccountPage({super.key});

  @override
  ConsumerState<BankAccountPage> createState() => _BankAccountPageState();
}

class _BankAccountPageState extends ConsumerState<BankAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  SupportedBank _selectedBank = kSupportedBanks.first;

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  void _prefillHolder(UserEntity user) {
    if (_accountHolderController.text.isEmpty) {
      _accountHolderController.text = user.namaLengkap;
    }
  }

  Future<void> _saveAccount(String userId) async {
    if (!_formKey.currentState!.validate()) return;

    final account = UserBankAccountEntity(
      id: const Uuid().v4(),
      userId: userId,
      bankCode: _selectedBank.code,
      bankName: _selectedBank.name,
      accountNumber: _accountNumberController.text.trim(),
      accountHolder: _accountHolderController.text.trim(),
      isPrimary: true,
      createdAt: DateTime.now(),
    );

    final success = await ref.read(bankAccountNotifierProvider.notifier).saveAccount(account);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening bank berhasil disimpan'), backgroundColor: Colors.green),
      );
      _accountNumberController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Harap login terlebih dahulu')));
    }

    _prefillHolder(user);
    final accountsAsync = ref.watch(userBankAccountsProvider(user.id));
    final isSaving = ref.watch(bankAccountNotifierProvider).isLoading;

    ref.listen<AsyncValue<void>>(bankAccountNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Rekening Bank')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          accountsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (accounts) {
              if (accounts.isEmpty) {
                return const Text(
                  'Belum ada rekening tersimpan. Tambahkan rekening untuk penarikan dana.',
                  style: TextStyle(color: Colors.black54),
                );
              }
              return Column(
                children: accounts.map((account) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.account_balance, color: Colors.blueAccent),
                      title: Text(account.bankName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${account.accountNumber}\n${account.accountHolder}',
                      ),
                      isThreeLine: true,
                      trailing: account.isPrimary
                          ? Chip(
                              label: const Text('Utama', style: TextStyle(fontSize: 11)),
                              backgroundColor: Colors.green.shade100,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text('Tambah Rekening', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<SupportedBank>(
                  value: _selectedBank,
                  decoration: const InputDecoration(
                    labelText: 'Bank',
                    border: OutlineInputBorder(),
                  ),
                  items: kSupportedBanks.map((bank) {
                    return DropdownMenuItem(value: bank, child: Text(bank.name));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedBank = value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Nomor Rekening',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.length < 8) ? 'Nomor rekening minimal 8 digit' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountHolderController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pemilik Rekening',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Nama pemilik wajib diisi' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : () => _saveAccount(user.id),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Simpan Rekening'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
