import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';
import 'package:singgah/features/trip/presentation/widgets/time_picker_sheet.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMapView = false;
  GoogleMapController? _mapController;
  int _selectedDay = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final trips = ref.watch(tripsProvider);
    final trip = trips.firstWhere((t) => t.id == widget.tripId, orElse: () => trips.first);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.map_outlined, color: Colors.white),
                      onPressed: () => setState(() => _isMapView = true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                      onPressed: () => _showDeleteTripConfirmation(trip),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAZ6SmGLFXGNx3IiOTf_g7xArRineuiAIyqijJlAGFZnJNOHXQ87yvG7kR2F3HJl29Sr60Ga-HiRRflnIyIECWesgW0sgI6kzSiN4EaZsTRhrWS1UKbapUghqQ_Ax9iE2B3KjIn8RABHXqAACW0Wq3JLMkwO-73a6ADkW8cOXmUs35kTdaykHniPJlpHkVJsIAygSI2ugThzoniyI2UobYPP2-hFdK-M0I6hN61mrpwXJGpRPGXoyOvPdGjpo2Fy46bGxPBlfkXvvw',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 48,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.name,
                                style: textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${trip.origin} → ${trip.destination}',
                                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Destinasi'),
                      Tab(text: 'Timeline'),
                      Tab(text: 'Hotel'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(trip),
                _buildDestinationsTab(trip),
                _buildTimelineTab(trip),
                _buildHotelTab(trip),
              ],
            ),
          ),
          if (_isMapView) _buildMapOverlay(trip),
        ],
      ),
      floatingActionButton: _isMapView ? null : FloatingActionButton(
        onPressed: () => context.push('/explore'),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteTripConfirmation(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Perjalanan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${trip.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              ref.read(tripsProvider.notifier).removeTrip(trip.id);
              context.go('/trips');
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Trip trip) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSummaryItem(Icons.route, 'Jarak', '${trip.itinerary.length * 12} km'),
              const SizedBox(width: 12),
              _buildSummaryItem(Icons.schedule, 'Waktu', '${trip.itinerary.length * 2}j'),
              const SizedBox(width: 12),
              _buildSummaryItem(Icons.local_gas_station, 'BBM', 'Rp ${(trip.itinerary.length * 50)}k'),
            ],
          ),
          const SizedBox(height: 32),
          Text('Ringkasan harian', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDaySummaryCard('Hari 1', trip.destination, '${trip.itinerary.length} Destinasi'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // AI Recommendation Card
          _buildAICard(colorScheme),
        ],
      ),
    );
  }

  Widget _buildAICard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primaryContainer, colorScheme.primary]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Saran Singgah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Berdasarkan rute Anda, kami menyarankan untuk singgah sebentar di destinasi searah agar perjalanan lebih efisien.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/explore'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: colorScheme.primary),
            child: const Text('Cari Tempat Searah'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(height: 4),
            Text(label, style: textTheme.labelSmall),
            Text(value, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySummaryCard(String day, String title, String count) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Text(count, style: textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildDestinationsTab(Trip trip) {
    if (trip.itinerary.isEmpty) return const Center(child: Text('Belum ada destinasi tersimpan.'));
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: trip.itinerary.length,
      itemBuilder: (context, index) => _buildDestinationCard(trip, trip.itinerary[index]),
    );
  }

  Widget _buildDestinationCard(Trip trip, Destination destination) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
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
            child: Image.network(destination.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: textTheme.titleMedium),
                Text(destination.category, style: textTheme.labelSmall?.copyWith(color: colorScheme.primary)),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete') {
                ref.read(tripsProvider.notifier).removeDestinationFromTrip(trip.id, destination.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'delete', child: Text('Hapus Destinasi')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(Trip trip) {
    final totalDays = trip.endDate.difference(trip.startDate).inDays + 1;
    final dayItinerary = trip.itinerary.where((d) => d.visitDay == _selectedDay).toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        // Day Selector Dinamis
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: List.generate(totalDays, (index) {
              final day = index + 1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('Hari $day'),
                  selected: _selectedDay == day,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedDay = day);
                  },
                  selectedColor: const Color(0xFF1B4332),
                  labelStyle: TextStyle(color: _selectedDay == day ? Colors.white : Colors.black87),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: dayItinerary.isEmpty
              ? _buildEmptyTimeline()
              : ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  onReorder: (oldIndex, newIndex) {
                    // Logika reorder khusus hari ini jika diperlukan
                  },
                  children: dayItinerary.asMap().entries.map((entry) => _buildTimelineItem(
                    key: ValueKey(entry.value.id),
                    tripId: trip.id,
                    destination: entry.value,
                    isLast: entry.key == dayItinerary.length - 1,
                    totalDays: totalDays,
                  )).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyTimeline() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Belum ada rencana untuk hari ini', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push('/explore'),
            child: const Text('Tambah Destinasi'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required Key key,
    required String tripId,
    required Destination destination,
    required int totalDays,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 24),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(color: Color(0xFF1B4332), shape: BoxShape.circle),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade200)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _showDestinationOptions(tripId, destination, totalDays),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(destination.arrivalTime ?? 'Pilih Jam', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                          const Spacer(),
                          const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(destination.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(destination.location, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDestinationOptions(String tripId, Destination destination, int totalDays) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(destination.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Atur Jam Kunjungan'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => TimePickerSheet(tripId: tripId, destination: destination),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Pindah ke Hari Lain'),
              onTap: () {
                Navigator.pop(context);
                _showDayPicker(tripId, destination, totalDays);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus dari Rencana', style: TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(tripsProvider.notifier).removeDestinationFromTrip(tripId, destination.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(String tripId, Destination destination, int totalDays) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pindah ke Hari', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: List.generate(totalDays, (index) {
                final day = index + 1;
                return ChoiceChip(
                  label: Text('Hari $day'),
                  selected: false,
                  onSelected: (_) {
                    ref.read(tripsProvider.notifier).updateDestination(tripId, destination.id, visitDay: day);
                    Navigator.pop(context);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOverlay(Trip trip) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<LatLng> points = trip.itinerary
        .where((d) => d.latitude != null && d.longitude != null)
        .map((d) => LatLng(d.latitude!, d.longitude!))
        .toList();

    final markers = trip.itinerary
        .where((d) => d.latitude != null && d.longitude != null)
        .map((d) => Marker(
              markerId: MarkerId(d.id),
              position: LatLng(d.latitude!, d.longitude!),
              infoWindow: InfoWindow(title: d.name, snippet: d.category),
            ))
        .toSet();

    return Container(
      color: colorScheme.surface,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: points.isNotEmpty ? points.first : const LatLng(-6.200000, 106.816666),
              zoom: 12,
            ),
            markers: markers,
            polylines: {
              if (points.length > 1)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: points,
                  color: colorScheme.primary,
                  width: 4,
                ),
            },
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.close, color: colorScheme.primary),
                onPressed: () => setState(() => _isMapView = false),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
              ),
              child: trip.itinerary.isEmpty 
                ? const Center(child: Text('Tidak ada destinasi untuk ditampilkan di peta'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trip.itinerary.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final dest = trip.itinerary[index];
                      return GestureDetector(
                        onTap: () {
                          if (dest.latitude != null && dest.longitude != null) {
                            _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(dest.latitude!, dest.longitude!)));
                          }
                        },
                        child: Container(
                          width: 250,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(dest.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dest.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text(dest.category, style: TextStyle(color: colorScheme.primary, fontSize: 11)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelTab(Trip trip) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (trip.hotel == null) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bed_outlined, size: 64, color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text('Belum ada hotel tersimpan', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Temukan akomodasi terbaik untuk perjalanan Anda.', textAlign: TextAlign.center, style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/explore'),
              child: const Text('Cari Hotel'),
            ),
          ],
        ),
      );
    }

    final hotel = trip.hotel!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Hotel yang tersimpan', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => context.push('/hotel-detail'),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    hotel.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hotel.name, style: textTheme.titleLarge),
                          Row(
                            children: [
                              Icon(Icons.star, color: colorScheme.secondary, size: 16),
                              const SizedBox(width: 4),
                              Text(hotel.rating.toString(), style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(hotel.location, style: textTheme.labelMedium),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tersimpan di Trip', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => ref.read(tripsProvider.notifier).removeHotelFromTrip(trip.id),
                            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
