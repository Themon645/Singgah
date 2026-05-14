import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class HotelDetailScreen extends ConsumerWidget {
  const HotelDetailScreen({super.key});

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
                // Carousel Hero
                Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAsmnYKCkW0Gay6bF9xKp5ctUkceemHg7UbVnq0WQ7uAuOG99Z_Nzk1XYO-dtWiJTK8BY_r677fqZR-OX3fC1hG0El5AJ_JrKfxBu9iYAz7I3dHtEZJrihOQoVCWG_kp7s0jbQwKs9hFJTpW66gi9L0vLycwjBVVPo0vtQ3DEjxLNDNceecXlzBfpHoIeSifAi9Q1F0vTOrX6hlNuUVFL0K37n6qWURWnPqmfYGZHspKlcnb5KIDZBDDXbu5BikEWp64c0QFPEwK6s',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 24, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4),
                          Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), shape: BoxShape.circle)),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Padma Hotel\nBandung',
                              style: textTheme.displayLarge?.copyWith(
                                color: colorScheme.primary,
                                height: 1.1,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: colorScheme.secondary, size: 16),
                                const SizedBox(width: 4),
                                Text('5.0', style: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          text: 'Rp 1.250.000 ',
                          style: textTheme.headlineMedium?.copyWith(color: colorScheme.secondary),
                          children: [
                            TextSpan(text: '/ malam', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tags
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildTag(context, 'Boutique'),
                          _buildTag(context, 'Valley View'),
                          _buildTag(context, 'Breakfast'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Amenities Grid
                      Row(
                        children: [
                          Expanded(child: _buildAmenityCard(context, Icons.wifi, 'WIFI', 'Gratis')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildAmenityCard(context, Icons.pool, 'KOLAM', 'Infinity')),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Facilities
                      Text('Fasilitas Populer', style: textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFacilityIcon(context, Icons.restaurant, 'Restoran'),
                          _buildFacilityIcon(context, Icons.spa, 'Spa'),
                          _buildFacilityIcon(context, Icons.fitness_center, 'Gym'),
                          _buildFacilityIcon(context, Icons.local_parking, 'Parkir'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Reviews
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ulasan Tamu', style: textTheme.titleLarge),
                          TextButton(onPressed: () {}, child: Text('Lihat Semua', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                                  child: Text('AS', style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Andi Saputra', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    Text('2 hari yang lalu', style: textTheme.labelSmall),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '"Pengalaman menginap yang luar biasa. Pemandangan lembahnya benar-benar menenangkan jiwa. Sarapannya pun sangat variatif dan lezat."',
                              style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
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
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => _showTripPicker(context, ref),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary, width: 2),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text('Simpan ke Trip'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Membuka Traveloka...')),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Buka di Traveloka'),
                          SizedBox(width: 8),
                          Icon(Icons.open_in_new, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: colorScheme.outline, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildAmenityCard(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(value, style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityIcon(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
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
            Text('Pilih Trip untuk Hotel', style: Theme.of(context).textTheme.headlineSmall),
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
                      subtitle: Text(trip.destination),
                      onTap: () async {
                        final hotel = Destination(
                          id: 'h1',
                          name: 'Padma Hotel Bandung',
                          category: 'Hotel',
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAsmnYKCkW0Gay6bF9xKp5ctUkceemHg7UbVnq0WQ7uAuOG99Z_Nzk1XYO-dtWiJTK8BY_r677fqZR-OX3fC1hG0El5AJ_JrKfxBu9iYAz7I3dHtEZJrihOQoVCWG_kp7s0jbQwKs9hFJTpW66gi9L0vLycwjBVVPo0vtQ3DEjxLNDNceecXlzBfpHoIeSifAi9Q1F0vTOrX6hlNuUVFL0K37n6qWURWnPqmfYGZHspKlcnb5KIDZBDDXbu5BikEWp64c0QFPEwK6s',
                          location: 'Ciumbuleuit, Bandung',
                          rating: 5.0,
                        );
                        
                        await ref.read(tripsProvider.notifier).setHotelForTrip(trip.id, hotel);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hotel berhasil disimpan ke trip ${trip.name}')),
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
}
