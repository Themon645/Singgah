import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Keamanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Ubah Password'),
            subtitle: const Text('Ganti password akun Anda secara berkala'),
            leading: const Icon(Icons.lock_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(context),
          ),
          ListTile(
            title: const Text('Autentikasi Dua Faktor'),
            subtitle: const Text('Tambahkan keamanan ekstra pada akun Anda'),
            leading: const Icon(Icons.verified_user_outlined),
            trailing: Switch(value: false, onChanged: (v) {}),
          ),
          ListTile(
            title: const Text('Perangkat Masuk'),
            subtitle: const Text('Lihat daftar perangkat yang mengakses akun Anda'),
            leading: const Icon(Icons.devices_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Password Lama')),
            TextField(decoration: InputDecoration(labelText: 'Password Baru')),
            TextField(decoration: InputDecoration(labelText: 'Konfirmasi Password Baru')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
