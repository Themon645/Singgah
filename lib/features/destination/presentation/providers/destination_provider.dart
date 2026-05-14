import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';

final destinationsProvider = Provider<List<Destination>>((ref) {
  return [
    Destination(
      id: 'd1',
      name: 'Tangkuban Perahu',
      category: 'Wisata Alam',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABiuBDs55LESkKItGACIZ0Ap2IaqBMcKKwlQOLNfomWinnwUKpBF5ZppqKo3ervnrGaGj7o0ydVNz7cMlaGeGVjP06ppelAjXiFTmKXcYZQVbMuaRa1X8L7KztyeOPujuaMWJ59R7giNoowsB3EEEtc7maDZbkMgRbf9o1uxEVxcP5tONaMLgRndqMfXKmhJi1eJlbt8w9Rt2RTH6-JKkRAUSSs1bNsliOCScriVEw5MUDFT1KE9-HJXSRumvrjKJ9MyRTqtidBcc',
      location: 'Lembang',
      rating: 4.8,
      latitude: -6.7596377,
      longitude: 107.5925345,
    ),
    Destination(
      id: 'd2',
      name: 'Lawangwangi Art',
      category: 'Seni & Budaya',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQo7_HSG3eBYkqW50ytifCeGAESXoNtnSI_im9MPtww6glvtWDbg-VRWSTcTQMMgoCcCp34Ai1gV3AnUBx9EBgYSWwlqU8xzRDNdrlZYV9jygyCblpdkPOiRYufPrQq7qQG6OFb5AcjSNVw3YT9sP4cxXhRqOfdZUOHY2WUeAfuoPYnzxYzTS3ECAkU5yOShHyI7dzC6fimLr0pJLXcyc7u67awT2pHJm51Y4nmjP3lrdgOb3PIbfA-A0t4gQ3Tg7JXKzRD9XmgJ8',
      location: 'Dago Pakar',
      rating: 4.7,
      latitude: -6.845585,
      longitude: 107.618685,
    ),
    Destination(
      id: 'd3',
      name: 'Kawah Putih',
      category: 'Wisata Alam',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDS4Im_Mrxh5PUvXtZqlIFt-BJv9ZLLrcqW0sv-fKkW3kvVPTzGg726kauIrC-dWDZ00FM7sHOmdbD-Ttxbvgkei-c4Vh3EJLkqWXBus-8h1EZi-6ju3PErELJzUUdxNlO0dLmCgp9nfA8OR6mNgqKJpK-7ul1hTUMdbagxlzUrs4zPHyEYH6rpeo_bLoH5TqkqNzWELeCEQw1_ELboFghSDA0BNATBm8R_Q8CQz8kFQnrjW_sctMVuQdoxQ1PYWbmoSmAjiL8lBrw',
      location: 'Ciwidey',
      rating: 4.9,
      latitude: -7.166204,
      longitude: 107.402135,
    ),
    Destination(
      id: 'd4',
      name: 'Braga Street',
      category: 'Seni & Budaya',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCrZ1nljcK7OzSLNFE-ErHa6rzjJQxoEjDbAWujvQnz6xshsGOqLNfd-ZPMX77qUf6LcurgZh3WUe5W91Ms2mcBRhb_as3g89U6X_4tiEpAn5tUkKP-IPYVYQ5SybKJPrCVfCXaOJNMXrTK1ScOfEYMlKhoi1SmctFRbdJLIaKQYBX94rzZJDWqeCqsCb3G-0ocyAWi4TYe3irmM8GrvpIOmBPWDZV4Cd_Vtpk_V5nkND1tnf5Gopx-jGsf0gtmegV3_NWsZ_4KG7Q',
      location: 'Heritage',
      rating: 4.6,
      latitude: -6.917637,
      longitude: 107.609104,
    ),
    Destination(
      id: 'd5',
      name: 'Seniman Coffee',
      category: 'Kuliner',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAs4qNZF9GHDkb4oUUnLWx5CCOpuAGl78kOYVMs4PruoqOhOKqUbE0ggGMBhBpFK9AfAY4lVXWFjfvaE3fhjYQLhCXXC7PahsE40ivqgL9zIXAlSkXpc9geQ1gbXIvtq9aVvkIVBcQaOVAzzlrPrKBWWKIkt6uM9RVYdHTcorfDLlo2vBHVsRwypgM4M7JrZbXi2NymkHXJhf_RtMkehCPagnuU9uA_yH-BYitnIw9GFbDkRlwko65IdqJDhol83cj2wjT_gnadYtw',
      location: 'Ubud',
      rating: 4.8,
      latitude: -8.506854,
      longitude: 115.262478,
    ),
  ];
});

final searchDestinationsProvider = Provider.family<List<Destination>, String>((ref, query) {
  final allDestinations = ref.watch(destinationsProvider);
  if (query.isEmpty) return [];
  return allDestinations.where((d) => 
    d.name.toLowerCase().contains(query.toLowerCase()) || 
    d.category.toLowerCase().contains(query.toLowerCase())
  ).toList();
});
