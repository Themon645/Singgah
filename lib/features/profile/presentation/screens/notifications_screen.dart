import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotif = true;
  bool _itineraryReminders = true;
  bool _promoNotif = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifikasi Push'),
            subtitle: const Text('Terima pemberitahuan langsung di perangkat'),
            value: _pushNotif,
            onChanged: (value) => setState(() => _pushNotif = value),
            activeColor: colorScheme.primary,
          ),
          SwitchListTile(
            title: const Text('Pengingat Itinerary'),
            subtitle: const Text('Dapatkan pengingat jadwal perjalanan harian'),
            value: _itineraryReminders,
            onChanged: (value) => setState(() => _itineraryReminders = value),
            activeColor: colorScheme.primary,
          ),
          SwitchListTile(
            title: const Text('Promo & Penawaran'),
            subtitle: const Text('Info destinasi populer dan diskon hotel'),
            value: _promoNotif,
            onChanged: (value) => setState(() => _promoNotif = value),
            activeColor: colorScheme.primary,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aktivitas Terbaru', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 16),
                _buildNotifItem(
                  'Trip Baru Berhasil Dibuat',
                  'Weekend di Bandung telah ditambahkan ke daftar perjalanan Anda.',
                  '2 jam yang lalu',
                  Icons.map,
                ),
                _buildNotifItem(
                  'Saran Destinasi',
                  'Seseorang menyarankan Tegalalang Rice Terrace untuk trip Bali Anda.',
                  'Kemarin',
                  Icons.auto_awesome,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifItem(String title, String desc, String time, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: colorScheme.primaryContainer.withOpacity(0.1),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 10, color: colorScheme.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
