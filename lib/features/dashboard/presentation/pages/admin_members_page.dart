import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../loan/presentation/providers/admin_loan_provider.dart';

class AdminMembersPage extends ConsumerWidget {
  const AdminMembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(allMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota Koperasi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
        data: (members) {
          if (members.isEmpty) {
            return const Center(
              child: Text('Belum ada anggota yang terdaftar.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey.shade100,
                    child: Text(
                      member.namaLengkap[0].toUpperCase(), 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 20),
                    ),
                  ),
                  title: Text(member.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('NIK: ${member.nik}', style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('Email: ${member.email}', style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('No. HP: ${member.noHp}', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}