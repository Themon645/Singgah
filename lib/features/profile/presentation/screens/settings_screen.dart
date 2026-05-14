import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('UMUM'),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Gunakan tema gelap untuk aplikasi'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tema akan diterapkan pada pembaruan mendatang')),
              );
            },
            activeColor: colorScheme.primary,
          ),
          ListTile(
            title: const Text('Bahasa'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(),
          ),
          const Divider(),
          _buildSectionHeader('AKUN'),
          ListTile(
            title: const Text('Email Terverifikasi'),
            subtitle: const Text('rara@email.com'),
            trailing: Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
          ),
          ListTile(
            title: const Text('Hapus Akun'),
            textColor: colorScheme.error,
            onTap: () => _showDeleteConfirmation(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 32, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          ListTile(
            title: const Text('Bahasa Indonesia'),
            onTap: () {
              setState(() => _selectedLanguage = 'Bahasa Indonesia');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('English (US)'),
            onTap: () {
              setState(() => _selectedLanguage = 'English (US)');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun?'),
        content: const Text('Seluruh data perjalanan Anda akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () => context.go('/auth'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
