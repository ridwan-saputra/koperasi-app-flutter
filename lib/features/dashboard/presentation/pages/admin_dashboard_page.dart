import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/quick_menu_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../loan/presentation/providers/admin_loan_provider.dart';
import '../../../saving/presentation/providers/withdraw_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(authNotifierProvider).value;
    final pendingLoansAsync = ref.watch(pendingLoansProvider);
    final pendingWithdrawalsAsync = ref.watch(pendingWithdrawalsProvider);
    final membersAsync = ref.watch(allMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halo, ${admin?.namaLengkap ?? 'Administrator'} 👋',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(pendingLoansProvider);
          ref.invalidate(pendingWithdrawalsProvider);
          ref.invalidate(allMembersProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              elevation: 6,
              shadowColor: Colors.blueGrey.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF607D8B), Color(0xFF90A4AE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Panel Admin',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      icon: Icons.request_quote_rounded,
                      label: 'Pinjaman menunggu',
                      asyncValue: pendingLoansAsync,
                      countBuilder: (loans) => loans.length,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Penarikan menunggu',
                      asyncValue: pendingWithdrawalsAsync,
                      countBuilder: (items) => items.length,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      icon: Icons.people_alt_rounded,
                      label: 'Total anggota',
                      asyncValue: membersAsync,
                      countBuilder: (members) => members.length,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Menu Cepat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickMenuButton(
                  icon: Icons.request_quote_rounded,
                  label: 'Pinjaman',
                  color: Colors.orange,
                  badgeCount: pendingLoansAsync.maybeWhen(
                    data: (loans) => loans.length,
                    orElse: () => null,
                  ),
                  onTap: () => context.push('/admin-loans'),
                ),
                QuickMenuButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Penarikan',
                  color: Colors.redAccent,
                  badgeCount: pendingWithdrawalsAsync.maybeWhen(
                    data: (items) => items.length,
                    orElse: () => null,
                  ),
                  onTap: () => context.push('/admin-withdraw'),
                ),
                QuickMenuButton(
                  icon: Icons.people_alt_rounded,
                  label: 'Anggota',
                  color: Colors.deepPurple,
                  onTap: () => context.push('/admin-members'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow<T> extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.asyncValue,
    required this.countBuilder,
  });

  final IconData icon;
  final String label;
  final AsyncValue<T> asyncValue;
  final int Function(T data) countBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
        asyncValue.when(
          data: (data) => Text(
            '${countBuilder(data)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          loading: () => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          error: (_, __) => const Icon(Icons.error_outline, color: Colors.white70, size: 20),
        ),
      ],
    );
  }
}
