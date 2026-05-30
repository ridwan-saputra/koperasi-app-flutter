import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/rupiah_input_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/constants/supported_banks.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/user_bank_account_entity.dart';
import '../providers/bank_account_provider.dart';
import '../providers/saving_provider.dart';
import '../providers/withdraw_provider.dart';

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({super.key});

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  UserBankAccountEntity? _selectedAccount;

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

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  Future<void> _submitWithdraw(String userId) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rekening tujuan penarikan'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final nominal = CurrencyFormatter.parse(_nominalController.text)!;
    final account = _selectedAccount!;

    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      userId: userId,
      type: 'WITHDRAW',
      nominal: nominal,
      status: 'PENDING',
      bankCode: account.bankCode,
      bankName: account.bankName,
      accountNumber: account.accountNumber,
      accountHolder: account.accountHolder,
      createdAt: DateTime.now(),
    );

    final success = await ref.read(withdrawNotifierProvider.notifier).requestWithdraw(transaction);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan penarikan berhasil. Menunggu persetujuan admin.'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/user-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final balanceState = ref.watch(balanceNotifierProvider);
    final isSubmitting = ref.watch(withdrawNotifierProvider).isLoading;

    ref.listen<AsyncValue<void>>(withdrawNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
          );
        },
      );
    });

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Harap login terlebih dahulu')));
    }

    final accountsAsync = ref.watch(userBankAccountsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik ke Bank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance),
            tooltip: 'Kelola Rekening',
            onPressed: () => context.push('/bank-account'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo Tersedia', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 4),
                    balanceState.when(
                      data: (b) => Text(
                        CurrencyFormatter.format(b),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) => const Text('Gagal memuat saldo'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimal penarikan ${CurrencyFormatter.format(kMinWithdrawAmount)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekening Tujuan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.push('/bank-account'),
                    child: const Text('+ Tambah'),
                  ),
                ],
              ),
              accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('Anda belum punya rekening bank tersimpan.'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => context.push('/bank-account'),
                              child: const Text('Tambah Rekening Bank'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  _selectedAccount ??= accounts.firstWhere(
                    (a) => a.isPrimary,
                    orElse: () => accounts.first,
                  );

                  return Column(
                    children: accounts.map((account) {
                      final isSelected = _selectedAccount?.id == account.id;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isSelected ? Colors.blue.shade50 : null,
                        child: RadioListTile<String>(
                          value: account.id,
                          groupValue: _selectedAccount?.id,
                          onChanged: (_) => setState(() => _selectedAccount = account),
                          title: Text(account.bankName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${account.accountNumber}\n${account.accountHolder}'),
                          isThreeLine: true,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [RupiahInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Nominal Penarikan',
                    hintText: 'Contoh: 500.000',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                    final nominal = CurrencyFormatter.parse(value);
                    if (nominal == null) return 'Nominal tidak valid';
                    if (nominal < kMinWithdrawAmount) {
                      return 'Minimal ${CurrencyFormatter.format(kMinWithdrawAmount)}';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isSubmitting ? null : () => _submitWithdraw(user.id),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Ajukan Penarikan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (isSubmitting)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
