import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/destination/presentation/providers/destination_provider.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class ExploreResultScreen extends ConsumerStatefulWidget {
  const ExploreResultScreen({super.key});

  @override
  ConsumerState<ExploreResultScreen> createState() => _ExploreResultScreenState();
}

class _ExploreResultScreenState extends ConsumerState<ExploreResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final searchResults = ref.watch(searchDestinationsProvider(_query));
    final trendingDestinations = ref.watch(destinationsProvider).take(2).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Cari destinasi atau kuliner...',
              hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: colorScheme.outline, size: 20),
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: _query.isEmpty 
          ? _buildEmptyState(trendingDestinations) 
          : _buildSearchResults(searchResults),
    );
  }

  Widget _buildEmptyState(List<Destination> trending) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pencarian populer', style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.outline)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSearchChip('Taman Hutan Raya'),
              _buildSearchChip('Kopi Dago'),
              _buildSearchChip('Dusun Bambu'),
              _buildSearchChip('Pasar Baru'),
            ],
          ),
          const SizedBox(height: 32),
          Text('Trending di Bandung', style: textTheme.headlineMedium),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              return _buildTrendingCard(trending[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return InkWell(
      onTap: () => _searchController.text = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }

  Widget _buildTrendingCard(Destination destination) {
    return InkWell(
      onTap: () => context.push('/destination-detail'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(destination.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(destination.location, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Destination> results) {
    final textTheme = Theme.of(context).textTheme;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            const Text('Tidak ada hasil ditemukan'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              _buildChip('Semua', true),
              _buildChip('Wisata Alam', false),
              _buildChip('Seni & Budaya', false),
              _buildChip('Kuliner', false),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text('Hasil pencarian untuk "$_query"', style: textTheme.headlineMedium),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return _buildResultCard(results[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {},
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : colorScheme.primary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
        ),
      ),
    );
  }

  Widget _buildResultCard(Destination destination) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/destination-detail'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(destination.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name, style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: colorScheme.secondary, size: 16),
                      const SizedBox(width: 4),
                      Text(destination.rating.toString(), style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: colorScheme.outlineVariant)),
                      const SizedBox(width: 8),
                      Text(destination.location, style: textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _showTripPicker(destination);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, color: colorScheme.primary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTripPicker(Destination destination) {
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
                      subtitle: Text(trip.destination),
                      onTap: () async {
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
}
