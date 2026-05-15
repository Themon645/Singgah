import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';
import 'package:singgah/features/destination/data/services/unsplash_service.dart';

class DestinationDetailScreen extends ConsumerWidget {
  final Destination? destination;

  const DestinationDetailScreen({super.key, this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Jika destination null (fallback), gunakan data dummy
    final currentDestination = destination ?? Destination(
      id: 'dummy',
      name: 'Lawangwangi Creative Space',
      category: 'Wisata',
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=800',
      location: 'Dago, Bandung',
      rating: 4.7,
    );

    // Ambil gambar dinamis HANYA jika imageUrl adalah placeholder
    final bool isPlaceholder = currentDestination.imageUrl.contains('unsplash.com') || currentDestination.imageUrl.contains('loremflickr.com');

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
                  height: 350,
                  width: double.infinity,
                  child: isPlaceholder 
                    ? Consumer(
                        builder: (context, ref, child) {
                          final unsplashAsync = ref.watch(FutureProvider<String>((ref) async {
                            final service = ref.watch(unsplashServiceProvider);
                            return service.getImageUrlByQuery('${currentDestination.name} ${currentDestination.location}');
                          }));
                          return unsplashAsync.when(
                            data: (url) => Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackImage(currentDestination)),
                            loading: () => _buildFallbackImage(currentDestination, showLoading: true),
                            error: (_, __) => _buildFallbackImage(currentDestination),
                          );
                        },
                      )
                    : Image.network(
                        currentDestination.imageUrl, 
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackImage(currentDestination),
                      ),
                ),
                
                // Content Card
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0EA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentDestination.category.toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF1B4332),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  currentDestination.rating.toStringAsFixed(1),
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentDestination.name,
                          style: textTheme.headlineLarge?.copyWith(
                            color: const Color(0xFF1B4332),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: colorScheme.primary, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                currentDestination.location,
                                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        Text('Tentang Destinasi', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(
                          _generateDescription(currentDestination),
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        Text('Informasi Penting', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildInfoCard(context, Icons.access_time, 'Info', _getOpeningHours(currentDestination))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInfoCard(context, Icons.confirmation_number_outlined, 'Estimasi', _getPricing(currentDestination))),
                          ],
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Back Button
          Positioned(
            top: 48,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4332)),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          
          // Footer Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _showTripPicker(context, ref, currentDestination),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4332),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_location_alt_outlined),
                    const SizedBox(width: 12),
                    Text('Tambah ke Rencana Perjalanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage(Destination dest, {bool showLoading = false}) {
    return Stack(
      children: [
        Image.network(dest.imageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        if (showLoading)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      ],
    );
  }

  String _generateDescription(Destination dest) {
    if (dest.category == 'Hotel') {
      return '${dest.name} adalah pilihan akomodasi populer di ${dest.location}. Hotel ini dikenal dengan pelayanannya yang ramah dan suasana yang tenang, sangat cocok untuk perjalanan bisnis maupun liburan keluarga.';
    } else if (dest.category == 'Cafe') {
      return '${dest.name} menawarkan pengalaman kuliner yang unik di ${dest.location}. Dengan desain interior yang estetik dan pilihan menu yang beragam, tempat ini menjadi favorit bagi warga lokal maupun wisatawan.';
    } else if (dest.category == 'Belanja') {
      return '${dest.name} merupakan pusat perbelanjaan yang lengkap di ${dest.location}. Anda bisa menemukan berbagai kebutuhan mulai dari fashion, kuliner, hingga hiburan dalam satu tempat.';
    }
    return 'Nikmati keindahan dan suasana unik di ${dest.name}. Tempat ini merupakan salah satu destinasi terpopuler di ${dest.location} yang menawarkan pengalaman tak terlupakan bagi setiap pengunjungnya.';
  }

  String _getOpeningHours(Destination dest) {
    final int seed = dest.id.hashCode;
    if (dest.category == 'Hotel') return 'Check-in 14:00';
    if (dest.category == 'Cafe') return '${8 + (seed % 3)}:00 - ${21 + (seed % 3)}:00';
    return '${9 + (seed % 2)}:00 - ${17 + (seed % 4)}:00';
  }

  String _getPricing(Destination dest) {
    final int seed = dest.id.hashCode;
    if (dest.category == 'Hotel') return 'Rp ${(400 + (seed % 10) * 100)}rb /mlm';
    if (dest.category == 'Cafe') return 'Rp ${(25 + (seed % 5) * 10)}rb - ${(100 + (seed % 10) * 20)}rb';
    return 'Rp ${(15 + (seed % 8) * 5)}rb - ${(75 + (seed % 5) * 10)}rb';
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1B4332), size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  void _showTripPicker(BuildContext context, WidgetRef ref, Destination destination) {
    final trips = ref.read(tripsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Rencana Trip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (trips.isEmpty)
              const Center(child: Text('Anda belum memiliki rencana trip.'))
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.map, color: Color(0xFF1B4332)),
                      title: Text(trip.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(trip.destination),
                      trailing: const Icon(Icons.add_circle, color: Color(0xFF1B4332)),
                      onTap: () async {
                        await ref.read(tripsProvider.notifier).addDestinationToTrip(trip.id, destination);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${destination.name} berhasil ditambahkan ke ${trip.name}')),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
