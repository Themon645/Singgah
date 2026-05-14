import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singgah/core/utils/profile_image_provider.dart';
import 'package:singgah/features/auth/presentation/providers/auth_provider.dart';
import 'package:singgah/features/trip/presentation/providers/trip_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authProvider);
    final trips = ref.watch(tripsProvider);

    final profileImage = buildProfileImage(user?.profilePicture);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profil',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: colorScheme.primaryContainer.withValues(
                        alpha: 0.1,
                      ),
                      backgroundImage: profileImage,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Petualang',
                    style: textTheme.headlineLarge,
                  ),
                  Text(
                    user?.email ?? 'petualang@singgah.com',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  _buildStatItem(context, trips.length.toString(), 'Trip'),
                  Container(
                    width: 1,
                    height: 40,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildStatItem(
                    context,
                    (trips.length * 3).toString(),
                    'Tempat',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildStatItem(
                    context,
                    trips.map((t) => t.destination).toSet().length.toString(),
                    'Kota',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu List
            _buildMenuItem(
              context,
              Icons.person_outline,
              'Edit Profil',
              () => context.push('/edit-profile'),
            ),
            _buildMenuItem(
              context,
              Icons.settings_outlined,
              'Pengaturan Akun',
              () => context.push('/settings'),
            ),
            _buildMenuItem(
              context,
              Icons.notifications_none_outlined,
              'Notifikasi',
              () => context.push('/notifications'),
            ),
            _buildMenuItem(
              context,
              Icons.security_outlined,
              'Keamanan',
              () => context.push('/security'),
            ),
            _buildMenuItem(
              context,
              Icons.help_outline,
              'Pusat Bantuan',
              () => context.push('/help-center'),
            ),

            const SizedBox(height: 24),
            // Logout
            InkWell(
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: colorScheme.error),
                    const SizedBox(width: 16),
                    Text(
                      'Keluar',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/trips');
          if (index == 2) context.go('/explore');
        },
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          Text(label, style: textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.outline),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: textTheme.titleLarge)),
            Icon(Icons.chevron_right, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
