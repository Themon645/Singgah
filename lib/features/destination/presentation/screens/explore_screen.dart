import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Jelajah',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Search Bar
            InkWell(
              onTap: () => context.push('/explore-result'),
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari destinasi atau kegiatan...',
                    prefixIcon: Icon(Icons.search, color: colorScheme.outline),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Popular Cities
            Text('Kota populer', style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildCityCard(context, 'Bandung', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAxLm54Hpd3esEZrZKlGDQq-u8y1Ih_HwsZLUwsiDHxuXWpATKDlFObjWVTmzWvtpplu44IgVFM-QiogEisa7h8u6VSESepo83z1DdUQjj6UDgGsp-Jjf7EzXIh1bEXbmVlhy7e-r7-LDCaWUD_K-vLlyj2oY9RDcgJcazB-ZWEPbBSZa7qpzAS56PynzDlAA-FZnSrqq9VZpoEiFqQmZ7ZxG32fg-buEFtSKVVgyMTe0JNUwIAz1fIz0fC6av0AWMEBpYGLPRHWSk'),
                _buildCityCard(context, 'Yogyakarta', 'https://lh3.googleusercontent.com/aida-public/AB6AXuCL1ulI8UYcJDAg9jijbYqlZ0ltfkJzGsw9ahKP9rjf4EUpIMtjGrKIyaBHTi46BMWNVOnDFDxXYlYhxVtg1Rn0DxyPSgqf-5BZbW0zrz8ieYobCsOsMcHYPfGDVkm5LbfJ1NhGrHZ4XUQ3sWgJjHoDOy5bmR_iYyOdEksZP7wny1IyAlDAYPwUqJzvRzVC4O-kUHq8ysxw2eOlliUfH2TQBg3ozW0dlgenmqSLLUwXmwoHe7VNo85TyM3m7jfn0F7kQsXMmUJZczc'),
                _buildCityCard(context, 'Malang', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhF3n6QisPqlE9iLFChm9v9MC0gTtI3QXDgR1y4u6cM-o8DKOXYthEa2TV8MEIPFSz6T8CA2DE2pjUqytlzX-3554rl3QdM_eOmPtvOVqz4LMumpDAlv-p_UlF5lA-kICI0Ng76oj7D0ZpSsbPW90g8ynRN617VolxLOQYFitjeaOlWiQFQRrUdygtx3uPTZH_VwwAyP4LXESCF3vzc86gU402i4gRkUelg_5UuCGbBH7MeHu3IPTICXqWzo1YFTC21IkT_Xfwkcg'),
                _buildCityCard(context, 'Bali', 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJy8j5dcHtgIJ6gxxr37rzVk-7h9CXuI2UtD4wZt0S_8-r6mMMiC9Za1JPuvfb13I7w6E0eKb4741U4SGLsNZmo1UAhemAQmP_rKSs7Syuz7igXBwL-6rlYrFp7nvsIOtK_NC3qk68_LqcBDGh7jfqaCPKvCw4mxItP_tynjeqIciFlu0TvbN4ql3decB9i7NSnPk-MQhalMh1cagfPIIRE0us8kIt9u0wzpksU2xV9L01idLfg46BNMGt5zok9xCtqn58V_wkn40'),
              ],
            ),
            const SizedBox(height: 32),

            // Categories
            Text('Kategori', style: textTheme.headlineMedium),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _buildCategoryItem(context, Icons.nature_people_outlined, 'Wisata', colorScheme.primaryContainer),
                _buildCategoryItem(context, Icons.coffee_outlined, 'Coffeeshop', colorScheme.secondaryContainer),
                _buildCategoryItem(context, Icons.museum_outlined, 'Budaya', colorScheme.tertiaryContainer),
                _buildCategoryItem(context, Icons.shopping_bag_outlined, 'Belanja', colorScheme.surfaceVariant),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: colorScheme.primary,
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

  Widget _buildCityCard(BuildContext context, String name, String imageUrl) {
    return InkWell(
      onTap: () => context.push('/explore-result'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Text(
                name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label, Color bgColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/explore-result'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(label, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
