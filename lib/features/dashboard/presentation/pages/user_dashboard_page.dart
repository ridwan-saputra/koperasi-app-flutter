import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../saving/presentation/providers/saving_provider.dart';

class UserDashboardPage extends ConsumerStatefulWidget {
  const UserDashboardPage({super.key});

  @override
  ConsumerState<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends ConsumerState<UserDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Menjalankan fungsi ambil saldo sesaat setelah kerangka UI selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        ref.read(balanceNotifierProvider.notifier).fetchBalance(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memantau data user yang sedang login
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value;
    
    // Memantau perubahan saldo
    final balanceState = ref.watch(balanceNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halo, ${user?.namaLengkap ?? 'Member'} 👋',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Keluar',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          )
        ],
      ),
      // RefreshIndicator memungkinkan user menarik layar ke bawah untuk refresh saldo
      body: RefreshIndicator(
        onRefresh: () async {
          if (user != null) {
            await ref.read(balanceNotifierProvider.notifier).fetchBalance(user.id);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // --- KARTU SALDO ---
            Card(
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Saldo Simpanan',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // Menampilkan UI berdasarkan status pengambilan data (Loading/Data/Error)
                    balanceState.when(
                      data: (balance) => Text(
                        'Rp ${balance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(color: Colors.white),
                      error: (error, stack) => Text(
                        'Gagal memuat saldo',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // --- MENU CEPAT ---
            const Text(
              'Menu Cepat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuButton(
                  context,
                  icon: Icons.add_circle_outline_rounded,
                  label: 'Simpan',
                  color: Colors.green,
                  onTap: () => context.push('/deposit'),
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.money_off_rounded,
                  label: 'Pinjam',
                  color: Colors.orange,
                  onTap: () => context.push('/loan-form'),
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.payments_rounded,
                  label: 'Cicilan',
                  color: Colors.teal,
                  onTap: () => context.push('/installment-payment'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenuButton(
                  context,
                  icon: Icons.history_rounded,
                  label: 'Riwayat',
                  color: Colors.purple,
                  onTap: () => context.push('/history'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget khusus (Komponen) untuk tombol menu agar kode lebih rapi
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}