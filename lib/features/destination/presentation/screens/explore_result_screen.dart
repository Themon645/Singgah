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
  String _selectedCity = '';
  String _selectedCategory = 'Semua';
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final state = GoRouterState.of(context);
      final query = state.uri.queryParameters['query'] ?? '';
      
      // Deteksi apakah query awal adalah kota populer atau kategori
      final cities = ['Bandung', 'Bali', 'Yogyakarta', 'Malang', 'Jakarta'];
      final categories = ['Wisata', 'Cafe', 'Hotel', 'Belanja'];

      if (cities.contains(query)) {
        _selectedCity = query;
      } else if (categories.contains(query)) {
        _selectedCategory = query;
      } else {
        _searchController.text = query;
      }
      _isInitialized = true;
    }
  }

  String get _combinedQuery {
    if (_searchController.text.isNotEmpty) return _searchController.text;
    
    String q = '';
    if (_selectedCategory != 'Semua') q += _selectedCategory;
    if (_selectedCity.isNotEmpty) q += ' $_selectedCity';
    
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
    
    // Gunakan query gabungan untuk mencari data
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
              onChanged: (val) => setState(() {}),
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: _selectedCity.isNotEmpty ? 'Cari di $_selectedCity...' : 'Cari destinasi...',
                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: colorScheme.outline, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty || _selectedCity.isNotEmpty
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
      body: _combinedQuery.isEmpty && _searchController.text.isEmpty
          ? _buildEmptyState(trendingDestinations) 
          : _buildSearchResults(searchResults),
    );
  }

  Widget _buildEmptyState(List<Destination> trending) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pencarian populer', style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildSearchChip('Kopi Dago'),
              _buildSearchChip('Taman Hutan Raya'),
              _buildSearchChip('Pasar Baru'),
            ],
          ),
          const SizedBox(height: 32),
          Text('Trending untukmu', style: textTheme.headlineMedium),
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
    );
  }

  Widget _buildSearchResults(List<Destination> results) {
    final textTheme = Theme.of(context).textTheme;
    
    String title = 'Hasil untuk ';
    if (_selectedCategory != 'Semua') title += '$_selectedCategory ';
    if (_selectedCity.isNotEmpty) title += 'di $_selectedCity';
    if (_searchController.text.isNotEmpty) title = 'Hasil untuk "${_searchController.text}"';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips (Kategori)
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
            ? _buildNoResult()
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
            _searchController.clear(); // Hapus search manual saat ganti kategori
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
          side: BorderSide(color: greenDark.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          const Text('Tidak ada hasil ditemukan di area ini.'),
        ],
      ),
    );
  }

  Widget _buildResultCard(Destination destination) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
              child: Image.network(destination.imageUrl, width: 80, height: 80, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: colorScheme.surfaceContainerHighest, child: const Icon(Icons.image_not_supported))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name, style: textTheme.titleMedium?.copyWith(color: const Color(0xFF1B4332), fontWeight: FontWeight.bold)),
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
    // Implementasi Picker Trip (Sama seperti sebelumnya)
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
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
            Positioned(bottom: 12, left: 12, right: 12, child: Text(destination.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
