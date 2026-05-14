import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class TripListScreen extends ConsumerStatefulWidget {
  const TripListScreen({super.key});

  @override
  ConsumerState<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends ConsumerState<TripListScreen> {
  String _selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final allTrips = ref.watch(tripsProvider);

    // Logic Filtering
    final filteredTrips = allTrips.where((trip) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Akan datang') return trip.status == TripStatus.upcoming;
      if (_selectedFilter == 'Berjalan') return trip.status == TripStatus.ongoing;
      if (_selectedFilter == 'Selesai') return trip.status == TripStatus.finished;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Perjalananku',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                _buildFilterChip('Akan datang'),
                _buildFilterChip('Berjalan'),
                _buildFilterChip('Selesai'),
              ],
            ),
          ),
          
          // Trip List
          Expanded(
            child: filteredTrips.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    final trip = filteredTrips[index];
                    return _buildTripCard(trip);
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-trip'),
        backgroundColor: colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Trip Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
        ],
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.go('/explore');
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_selectedFilter != 'Semua') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.filter_list_off, size: 48, color: colorScheme.outlineVariant),
            ),
            const SizedBox(height: 24),
            Text('Tidak ada perjalanan', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tidak ada perjalanan dengan status "$_selectedFilter"',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.map_rounded, size: 80, color: colorScheme.primary),
          ),
          const SizedBox(height: 32),
          Text(
            'Selamat Datang di Singgah!',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada petualangan yang tercatat. Mulai rencanakan perjalanan impianmu sekarang!',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          
          _buildIntroStep(
            Icons.add_location_alt_outlined,
            'Buat Rencana',
            'Tentukan destinasi dan tanggal perjalananmu dengan mudah.',
          ),
          _buildIntroStep(
            Icons.checklist_rounded,
            'Atur Itinerary',
            'Susun jadwal kegiatan harian agar perjalanan lebih teratur.',
          ),
          _buildIntroStep(
            Icons.people_outline,
            'Ajak Teman',
            'Bagikan rencana perjalananmu dan kelola bersama teman.',
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/create-trip'),
              icon: const Icon(Icons.add),
              label: const Text('Mulai Perjalanan Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroStep(IconData icon, String title, String description) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 4),
                Text(
                  description, 
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('dd MMM yyyy');

    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;
    double progressValue;

    switch (trip.status) {
      case TripStatus.upcoming:
        statusBgColor = colorScheme.secondaryContainer.withValues(alpha: 0.5);
        statusTextColor = colorScheme.onSecondaryContainer;
        statusLabel = 'Akan datang';
        progressValue = 0.05; // Sedikit terlihat agar tidak kosong
        break;
      case TripStatus.ongoing:
        statusBgColor = colorScheme.primaryContainer.withValues(alpha: 0.2);
        statusTextColor = colorScheme.primary;
        statusLabel = 'Berjalan';
        progressValue = trip.progress > 0 ? trip.progress : 0.4;
        break;
      case TripStatus.finished:
        statusBgColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
        statusTextColor = colorScheme.onSurfaceVariant;
        statusLabel = 'Selesai';
        progressValue = 1.0;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: trip.status == TripStatus.ongoing ? colorScheme.primary : colorScheme.outlineVariant,
          width: trip.status == TripStatus.ongoing ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/trip-detail/${trip.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        trip.name,
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: statusTextColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Custom Progress Bar
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progressValue,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: trip.status == TripStatus.finished 
                              ? colorScheme.outline 
                              : (trip.status == TripStatus.ongoing ? colorScheme.primary : colorScheme.secondary),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: colorScheme.outline),
                        const SizedBox(width: 8),
                        Text(
                          '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    if (trip.status == TripStatus.ongoing)
                      Text(
                        'Hari ke 4 dari 7', // Mock logic for day
                        style: textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                      )
                    else if (trip.status == TripStatus.finished)
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
