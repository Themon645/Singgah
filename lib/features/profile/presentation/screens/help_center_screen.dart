import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari bantuan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            Text('FAQ', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildFaqItem('Bagaimana cara membuat trip baru?', 'Anda dapat menekan tombol "+" di halaman utama atau tab Perjalanan.'),
            _buildFaqItem('Apakah saya bisa mengedit itinerary bersama teman?', 'Ya, gunakan fitur bagikan link pada detail trip untuk mengundang teman.'),
            _buildFaqItem('Bagaimana cara membatalkan reservasi hotel?', 'Singgah hanya merujuk pada platform partner. Silakan cek aplikasi Traveloka Anda.'),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primaryContainer.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text('Masih butuh bantuan?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tim kami siap membantu Anda 24/7', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Hubungi CS via WhatsApp'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ],
    );
  }
}
