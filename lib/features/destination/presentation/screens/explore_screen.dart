import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/destination_provider.dart';
import '../../domain/entities/destination.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final allDestinations = ref.watch(destinationsProvider);
    
    // Data dari API (Overpass/Google)
    final nearbyAsync = ref.watch(nearbyDestinationsProvider((lat: -6.2088, lon: 106.8456)));
    final googleHotelsAsync = ref.watch(googleHotelsProvider((lat: -6.2088, lon: 106.8456)));
    final googleWisataAsync = ref.watch(googleWisataProvider((lat: -6.2088, lon: 106.8456)));
    final googleCafeAsync = ref.watch(googleCafeProvider((lat: -6.2088, lon: 106.8456)));
    final googleShopAsync = ref.watch(googleShopProvider((lat: -6.2088, lon: 106.8456)));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  'Jelajah',
                  style: textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: const Color(0xFF1B4332),
                  ),
                ),
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () => context.push('/explore-result'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Text(
                          'Cari destinasi atau kegiatan...',
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
        
              // Category Icons
              _buildCategorySection(context),
              
              const SizedBox(height: 32),

              // --- SEKSI CAFE (API & Lokal) ---
              googleCafeAsync.when(
                data: (cafes) {
                  if (cafes.isEmpty) return _buildCitySection(context, 'Cafe di Bandung', 
                      allDestinations.where((d) => d.category == 'Cafe' && d.location.contains('Bandung')).toList(), 'Cafe Bandung');
                  return _buildCitySection(context, 'Cafe Populer (API)', cafes, 'Cafe');
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => _buildCitySection(context, 'Cafe di Bandung', 
                      allDestinations.where((d) => d.category == 'Cafe' && d.location.contains('Bandung')).toList(), 'Cafe Bandung'),
              ),
              
              const SizedBox(height: 16),
              const Divider(indent: 20, endIndent: 20),
              const SizedBox(height: 24),

              // --- SEKSI HOTEL (DATA API) ---
              googleHotelsAsync.when(
                data: (hotels) {
                  if (hotels.isEmpty) {
                    return _buildCitySection(context, 'Penginapan di Bandung', 
                      allDestinations.where((d) => d.category == 'Hotel' && d.location.contains('Bandung')).toList(), 'Hotel Bandung');
                  }
                  return _buildCitySection(context, 'Penginapan Populer (API)', hotels, 'Hotel');
                },
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )),
                error: (err, stack) {
                  debugPrint('Error loading API Hotels: $err');
                  return _buildCitySection(context, 'Penginapan di Bandung', 
                    allDestinations.where((d) => d.category == 'Hotel' && d.location.contains('Bandung')).toList(), 'Hotel Bandung');
                },
              ),

              const SizedBox(height: 16),
              const Divider(indent: 20, endIndent: 20),
              const SizedBox(height: 24),

              // --- SEKSI WISATA TERDEKAT (DATA API) ---
              googleWisataAsync.when(
                data: (places) => _buildCitySection(context, 'Wisata Terpopuler (API)', places, 'Wisata'),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),

              // --- SEKSI WISATA (Data Lokal) ---
              _buildCitySection(context, 'Wisata di Yogyakarta', 
                  allDestinations.where((d) => d.category == 'Wisata' && d.location.contains('Yogyakarta')).toList(), 'Wisata Yogyakarta'),
              _buildCitySection(context, 'Wisata di Bandung', 
                  allDestinations.where((d) => d.category == 'Wisata' && d.location.contains('Bandung')).toList(), 'Wisata Bandung'),

              // --- SEKSI BELANJA (API) ---
              googleShopAsync.when(
                data: (shops) => _buildCitySection(context, 'Pusat Belanja (API)', shops, 'Belanja'),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: const Color(0xFF1B4332),
        unselectedItemColor: colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        ],
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/trips');
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCategoryChip(context, Icons.travel_explore, 'Wisata'),
          const SizedBox(width: 20),
          _buildCategoryChip(context, Icons.local_cafe_outlined, 'Cafe'),
          const SizedBox(width: 20),
          _buildCategoryChip(context, Icons.bed_outlined, 'Hotel'),
          const SizedBox(width: 20),
          _buildCategoryChip(context, Icons.shopping_bag_outlined, 'Belanja'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () => context.push('/explore-result?query=$label'),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0EA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1B4332), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }

  Widget _buildCitySection(BuildContext context, String title, List<Destination> items, String query) {
    if (items.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1B4332))),
              InkWell(
                onTap: () => context.push('/explore-result?query=$query'),
                child: const Text('Lihat Semua', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length > 3 ? 3 : items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () => context.push('/destination-detail', extra: item),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(item.location, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(item.rating.toString(), style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 20, color: colorScheme.outline),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
