import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/features/home/domain/services/travel_reminder_service.dart';
import 'package:singgah/features/home/presentation/widgets/travel_reminder_list_widget.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';
import 'package:singgah/features/destination/presentation/providers/destination_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final trips = ref.watch(tripsProvider);
    final reminderItems = TravelReminderService.buildTravelReminders(
      trips,
      DateTime.now(),
    );

    final upcomingTrip = trips
        .where((t) => t.status == TripStatus.upcoming)
        .firstOrNull;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png', 
                          height: 32,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.location_on, color: Color(0xFF1B4332), size: 32),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Singgah',
                          style: textTheme.displayLarge?.copyWith(
                            color: const Color(0xFF1B4332),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Petualang 👋',
                      style: textTheme.headlineLarge,
                    ),
                    Text(
                      'Siap untuk petualangan baru?',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upcomingTrip != null
                            ? 'PERJALANAN MENDATANG'
                            : 'BELUM ADA TRIP',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        upcomingTrip?.name ?? 'Mulai rencanakan liburanmu',
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      if (upcomingTrip != null) ...[
                        Row(
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 24,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundImage: NetworkImage(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBh6vC5v2DYuuxr9yusD4-0VOKKCsEKiCwSd2AOxfAH1Jz7DdAobFl_VISc7x8cOMJd_pql2THwxR5C2Zxa1Hn_bSpVehUc55m5oI_D5RQL33tnagYb1BfjjW8HReTB9n3yiu9wm9gmXHa05-wwZ1oYcXf-DFrs10BspUKiinP4nXQmmqDK5XXpdmi8MEm3kRHaKQaX-25Z-BKsFBfUHKSAY1jJ_HYlgzi_w8R1FqZ2T4s1rLrCMTXVIvPKxKCzM4MbCR2v-O9f1VA',
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 12,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundImage: NetworkImage(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAtVwtB8QQ3R-y2Le-bO4jwAcIAgApv8G3Y-fhdj5AxJKaxRZZUqZVhIjq-ZhLLe-WBkeHAz_Qeqt4ryffWuBjMzIhspdHT49XG7irhLJv5peWr1Qamli6Y1uy6wMS1AZFr-M1f8j41BWFZwA1M6bIujodNB5Tecc5sxh7LKiBOlaW3bYBwhrd_Ee_SfMUF3N-c5GWY5qFEWNn3Vxisz3o0WWGnOmVI5gkS6xyWRLqSEw_Vq4rE8OHs5dBtGcV6j4C2UABxZaPjc8o',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Beserta teman perjalananmu',
                              style: textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      ElevatedButton(
                        onPressed: () => context.push(
                          upcomingTrip != null
                              ? '/trip-detail/${upcomingTrip.id}'
                              : '/create-trip',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              upcomingTrip != null
                                  ? 'Buka itinerary →'
                                  : 'Buat Trip Sekarang',
                            ),
                            const Icon(Icons.calendar_today_outlined, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TravelReminderListWidget(reminders: reminderItems),
              ),
              const SizedBox(height: 32),
              _buildNearbySection(context, ref),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Inspirasi untukmu', style: textTheme.headlineMedium),
                    InkWell(
                      onTap: () => context.go('/explore'),
                      child: Text(
                        'Lihat Semua',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildInspirationCard(
                      context,
                      'Ubud, Bali',
                      'Wisata Ketenangan',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDeu8BZvK6tKbZ06eAs0oVjxNYsYJ2PiAI8rDzv4rmcget5T_FKZJlKouTYCEDyOUMwgoiGooGWfBqBmvHmJ4WFEV5nIld4SzochSJeh-KXew0fK9sttLcXP67xiK40JNiNQ8EgHA1lOtjL-b9-mZPjQKj-VLlf6o0IOaeEQr2SISPiOHzRFeq3u-faGvxocGJ1nutC3WY40NnBwj40mXLG6QAINs2iNXbwjOD0v2PJhRKwgpvq1s0ROgxqTnosmY6XcFme7Zvv0Fw',
                    ),
                    const SizedBox(width: 16),
                    _buildInspirationCard(
                      context,
                      'Yogyakarta',
                      'Budaya & Sejarah',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA59yo-lXdDKrHeJRB-kXdG6x3-HzfrR1QD78llmmrDbCuJVO0IMM4d4eqt9KQ5kP2CSinbgPAC225-fKdwu5vvbBA8AFwehtNme6x8SBQH_Ns-eC40Josz5o4K2gyVjI4gCgFY6FsYkC9lGN3GnR8h0xCZ-cSNBNcxxut80Nwq2NwGMDJfOM5HZXWhbw5MUz1EnyZdB9eFvOnkGO0wWLRQqLkRzglb-LnipHD91COE4iie-e3aq5HwupA--b6PQ4Wvc8ZOOC-xWXY',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () => context.push('/create-trip'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primaryContainer,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.primaryContainer,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Mulai trip baru',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rencanakan petualanganmu selanjutnya dengan mudah',
                          textAlign: TextAlign.center,
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
        ],
        onTap: (index) {
          if (index == 1) context.go('/trips');
          if (index == 2) context.go('/explore');
        },
      ),
    );
  }

  Widget _buildInspirationCard(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/destination-detail'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(subtitle, style: textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySection(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Mock koordinat Jakarta untuk contoh. Bisa diganti dengan geolocator nantinya.
    final nearbyPlaces = ref.watch(nearbyDestinationsProvider((lat: -6.2088, lon: 106.8456)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tempat menarik di sekitarmu', style: textTheme.headlineMedium),
              Icon(Icons.near_me, size: 18, color: colorScheme.primary),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: nearbyPlaces.when(
            data: (places) {
              if (places.isEmpty) {
                return Center(child: Text('Tidak ada tempat ditemukan', style: textTheme.bodyMedium));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildInspirationCard(
                      context,
                      place.name,
                      place.category,
                      place.imageUrl,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text('Gagal memuat data: $err', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
