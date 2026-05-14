import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class DestinationDetailScreen extends ConsumerWidget {
  const DestinationDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDarE6j0SMbRGRu9RbmtXfab2wqdyTES-sCPMwkAcBrKK0iQYGHIrq0YdV6R1iA6WQf-_0_rKSRP7Chj4SJhrpKayggZaAFuQh983Yu8wGoJuAnvW7j_CV1hPFnL4x2xfDJzFhvhA1ZEgu3ihAY24o72pQbD-3EVAUf9i-6LBQsI2W8WkWJtn6lYHgq7KKxcM8kgLK1tk71Xm62LrBc8P8NMUWIsxJAqp_U0QyVPkIljHybtHPzFZAW73L-uxaPVuVR6tnbpQziQ_s',
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Content Card
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges
                        Row(
                          children: [
                            _buildBadge(context, 'Seni & Budaya', colorScheme.primaryContainer.withOpacity(0.1), colorScheme.primary),
                            const SizedBox(width: 8),
                            _buildBadge(context, 'Buka', colorScheme.secondary.withOpacity(0.1), colorScheme.secondary),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lawangwangi Creative Space',
                          style: textTheme.headlineLarge?.copyWith(color: colorScheme.primary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: colorScheme.secondary, size: 18),
                            const SizedBox(width: 4),
                            Text('4.7', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text(' (1,240 ulasan)', style: textTheme.labelMedium),
                            const SizedBox(width: 12),
                            Text('•', style: TextStyle(color: colorScheme.outline)),
                            const SizedBox(width: 12),
                            Text('Dago, Bandung', style: textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Info Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(context, Icons.schedule, 'JAM BUKA', '10:00 - 21:00'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(context, Icons.payments_outlined, 'TIKET MASUK', 'Gratis'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Location
                        Text('Lokasi', style: textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'Jl. Dago Giri No.99, Mekarwangi, Kec. Lembang, Kabupaten Bandung Barat, Jawa Barat 40391',
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 32),
                        
                        // Gallery
                        Text('Galeri Foto', style: textTheme.titleLarge),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildGalleryImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBGELuxyhWPHgA5K88MFDRDEwIbMDEpdXSvGnmJUttlNPRZMV6S267N0KPMJP5upgwP0Pw9LtKcdmCu-46Tjnftv2en1JfrpVRWna0tNofb9u3PymLTNMA1XHIU9xPWlZdKvlxi4H7kMoeB7QHbIvkQ488R_ZQJTnt-IB1BkekO_hD2VvxUv5S_8aYZGiEmfU4_T8x5xMZNBv3egHsdRZqDjCwLFCx5HkRoYsFhk1zbUvd_6ZNmIv_NHvoUfPSTnyrM2-1992adDDM'),
                              const SizedBox(width: 12),
                              _buildGalleryImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBZvJKKmnS0k3-IOUclZmhfyBUL3DivzS3Agf-NZLWqBCmV-j4UaAdyBe4YEwcnXI9PvN9j0tShBJhEF7gbaTMwrP2EkJUoV1mle_WyRWdHLrmXOPPjJIaXNSgO4Au63MImfzVfqCHYlVXHfyeKE-EwH9t_Jet-pMhnF2qC9zQqFwUhQ-jfUwkAfN-4_zlNiAQvVKWm_pTkd6xtjw8tL_7E5PJ5rH5Xw7CCfbNmWgqNgzUDCnCPaIjwiTNw534aqyCD2T6OnuEFdqA'),
                              const SizedBox(width: 12),
                              _buildGalleryImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDk7hqWXa3Ie05VbK80ahEms7d5H2W99Y0dgjSOKZSh5L1Q0oWyN7GcxyHeJ-zNNiGDliiIkiRfc8w3xCXd7WCNdCRDAdcdeIL46gE3tpB6Jax101haaG5au2ayhfIDx4uYRe-BoNBrsilReouHQbxFhZC7-BcmnlzQWvKPy21x5gCnIexQZ042WVWaAOGzkZ-DLBaMKOjNFT3qj8OWNbxeflny3cNu3ZHR6m69jq1CIFHcPnIwqnr1ty_pIYJ-dm5GYdwiL4bo7iU'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Back Button Overlay
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          
          // Sticky Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: ElevatedButton(
                onPressed: () => _showTripPicker(context, ref),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline),
                    const SizedBox(width: 8),
                    const Text('Tambah ke trip'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTripPicker(BuildContext context, WidgetRef ref) {
    final trips = ref.read(tripsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Trip', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (trips.isEmpty)
              const Center(child: Text('Belum ada trip. Buat trip baru terlebih dahulu.'))
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return ListTile(
                      leading: Icon(Icons.map, color: colorScheme.primary),
                      title: Text(trip.name),
                      subtitle: Text('${trip.destination}'),
                      onTap: () async {
                        final destination = Destination(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: 'Lawangwangi Creative Space',
                          category: 'Seni & Budaya',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQo7_HSG3eBYkqW50ytifCeGAESXoNtnSI_im9MPtww6glvtWDbg-VRWSTcTQMMgoCcCp34Ai1gV3AnUBx9EBgYSWwlqU8xzRDNdrlZYV9jygyCblpdkPOiRYufPrQq7qQG6OFb5AcjSNVw3YT9sP4cxXhRqOfdZUOHY2WUeAfuoPYnzxYzTS3ECAkU5yOShHyI7dzC6fimLr0pJLXcyc7u67awT2pHJm51Y4nmjP3lrdgOb3PIbfA-A0t4gQ3Tg7JXKzRD9XmgJ8',
                          location: 'Dago, Bandung',
                          latitude: -6.845585,
                          longitude: 107.618685,
                        );
                        
                        await ref.read(tripsProvider.notifier).addDestinationToTrip(trip.id, destination);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Berhasil ditambahkan ke trip ${trip.name}')),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(label, style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(url, width: 140, height: 100, fit: BoxFit.cover),
    );
  }
}
