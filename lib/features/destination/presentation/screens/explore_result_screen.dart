import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/destination/presentation/providers/destination_provider.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class ExploreResultScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const ExploreResultScreen({super.key, this.initialQuery});

  @override
  ConsumerState<ExploreResultScreen> createState() => _ExploreResultScreenState();
}

class _ExploreResultScreenState extends ConsumerState<ExploreResultScreen> {
  late final TextEditingController _searchController;
  String _selectedCity = '';
  String _selectedCategory = 'Semua';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final query = widget.initialQuery ?? '';
      if (query.isNotEmpty) {
        final cities = ['Bandung', 'Bali', 'Yogyakarta', 'Malang', 'Jakarta'];
        final categories = ['Wisata', 'Cafe', 'Hotel', 'Belanja'];

        if (cities.contains(query)) {
          _selectedCity = query;
          _searchController.clear();
        } else if (categories.contains(query)) {
          _selectedCategory = query;
          _searchController.clear();
        }
      }
      _isInitialized = true;
    }
  }

  String get _combinedQuery {
    if (_searchController.text.isNotEmpty) return _searchController.text;
    
    String q = '';
    if (_selectedCategory != 'Semua') q += '$_selectedCategory ';
    if (_selectedCity.isNotEmpty) q += _selectedCity;
    
    return q.trim();
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
    
    final searchResults = ref.watch(searchDestinationsProvider(_combinedQuery));
    final trendingDestinations = ref.watch(destinationsProvider).take(2).toList();

    const Color greenDark = Color(0xFF1B4332);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: greenDark),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: TextField(
              controller: _searchController,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: _selectedCity.isNotEmpty ? 'Cari di $_selectedCity...' : 'Cari destinasi...',
                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: colorScheme.outline, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: (_searchController.text.isNotEmpty || _selectedCity.isNotEmpty)
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _selectedCity = '';
                          _selectedCategory = 'Semua';
                        });
                      },
                    )
                  : null,
              ),
            ),
          ),
        ),
      ),
      body: (_combinedQuery.isEmpty)
          ? _buildEmptyState(trendingDestinations) 
          : _buildSearchResults(searchResults),
    );
  }

  Widget _buildEmptyState(List<Destination> trending) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
              _buildSearchChip('Kopi Dago'),
              _buildSearchChip('Taman Hutan Raya'),
              _buildSearchChip('Pasar Baru'),
            ],
          ),
          const SizedBox(height: 32),
          Text('Trending untukmu', style: textTheme.headlineMedium),
          const SizedBox(height: 16),
          if (trending.isEmpty)
            const Center(child: Text('Tidak ada data trending'))
          else
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
              itemBuilder: (context, index) => _buildTrendingCard(trending[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() => _searchController.text = label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      labelStyle: Theme.of(context).textTheme.labelMedium,
    );
  }

  Widget _buildSearchResults(List<Destination> results) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    String title = 'Hasil untuk ';
    if (_selectedCategory != 'Semua') title += '$_selectedCategory ';
    if (_selectedCity.isNotEmpty) title += 'di $_selectedCity';
    if (_searchController.text.isNotEmpty) title = 'Hasil untuk "${_searchController.text}"';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              _buildCategoryFilterChip('Semua'),
              _buildCategoryFilterChip('Wisata'),
              _buildCategoryFilterChip('Cafe'),
              _buildCategoryFilterChip('Hotel'),
              _buildCategoryFilterChip('Belanja'),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(title, style: textTheme.headlineMedium),
        ),
        
        Expanded(
          child: results.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    const Text('Tidak ada hasil ditemukan di area ini.'),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: results.length,
                itemBuilder: (context, index) => _buildResultCard(results[index]),
              ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilterChip(String label) {
    const Color greenDark = Color(0xFF1B4332);
    bool isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: isSelected,
        checkmarkColor: Colors.white,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
            _searchController.clear();
          });
        },
        backgroundColor: Colors.white,
        selectedColor: greenDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : greenDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: greenDark.withValues(alpha: 0.2)),
        ),
      ),
    );
  }

  Widget _buildResultCard(Destination destination) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push('/destination-detail', extra: destination),
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
              child: Image.network(
                destination.imageUrl, 
                width: 80, 
                height: 80, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80, 
                  height: 80, 
                  color: colorScheme.surfaceContainerHighest, 
                  child: const Icon(Icons.image_not_supported)
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name, 
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF1B4332), 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: colorScheme.secondary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        destination.rating.toString(), 
                        style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: colorScheme.outlineVariant)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          destination.location, 
                          style: textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
              onPressed: () => _showTripPicker(destination),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Belum ada trip. Buat trip baru terlebih dahulu.')),
              )
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

  Widget _buildTrendingCard(Destination destination) {
    return InkWell(
      onTap: () => context.push('/destination-detail', extra: destination),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              destination.imageUrl, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, 
                  end: Alignment.bottomCenter, 
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)]
                )
              ),
            ),
            Positioned(
              bottom: 12, 
              left: 12, 
              right: 12, 
              child: Text(
                destination.name, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
