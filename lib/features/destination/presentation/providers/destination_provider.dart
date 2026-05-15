import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/destination/data/services/overpass_service.dart';
import 'package:singgah/features/destination/data/services/google_places_service.dart';
import 'package:singgah/features/destination/data/services/tripadvisor_service.dart';

final destinationsProvider = Provider<List<Destination>>((ref) {
  return [
    // BANDUNG
    Destination(
      id: 'b1',
      name: 'Kopi Toko Djawa',
      category: 'Cafe',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=400',
      location: 'Braga, Bandung',
      rating: 4.8,
    ),
    Destination(
      id: 'b2',
      name: 'The Gaia Hotel',
      category: 'Hotel',
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400',
      location: 'Setiabudi, Bandung',
      rating: 4.9,
    ),
    Destination(
      id: 'b3',
      name: 'Kawah Putih',
      category: 'Wisata',
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400',
      location: 'Ciwidey, Bandung',
      rating: 4.7,
    ),
    
    // BALI
    Destination(
      id: 'ba1',
      name: 'Sisterfields Cafe',
      category: 'Cafe',
      imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec41b50d?q=80&w=400',
      location: 'Seminyak, Bali',
      rating: 4.6,
    ),
    Destination(
      id: 'ba2',
      name: 'Ayana Resort',
      category: 'Hotel',
      imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=400',
      location: 'Jimbaran, Bali',
      rating: 4.9,
    ),
    Destination(
      id: 'ba3',
      name: 'Tanah Lot',
      category: 'Wisata',
      imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=400',
      location: 'Tabanan, Bali',
      rating: 4.8,
    ),

    // JOGJA
    Destination(
      id: 'j1',
      name: 'Tempo Gelato',
      category: 'Cafe',
      imageUrl: 'https://images.unsplash.com/photo-1501443762994-82bd5dace89a?q=80&w=400',
      location: 'Prawirotaman, Yogyakarta',
      rating: 4.7,
    ),
    Destination(
      id: 'j2',
      name: 'Amanjiwo',
      category: 'Hotel',
      imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4df85b?q=80&w=400',
      location: 'Borobudur, Yogyakarta',
      rating: 5.0,
    ),
  ];
});

final searchDestinationsProvider = Provider.family<List<Destination>, String>((ref, query) {
  final allDestinations = ref.watch(destinationsProvider);
  final nearbyAsync = ref.watch(nearbyDestinationsProvider((lat: -6.2088, lon: 106.8456)));
  final googleHotelsAsync = ref.watch(googleHotelsProvider((lat: -6.2088, lon: 106.8456)));
  
  List<Destination> combinedList = [...allDestinations];
  
  nearbyAsync.whenData((places) {
    for (var place in places) {
      if (!combinedList.any((d) => d.id == place.id)) combinedList.add(place);
    }
  });

  googleHotelsAsync.whenData((hotels) {
    for (var hotel in hotels) {
      if (!combinedList.any((d) => d.id == hotel.id)) combinedList.add(hotel);
    }
  });

  if (query.isEmpty || query.toLowerCase() == 'semua') return combinedList;
  final lowerQuery = query.toLowerCase();
  
  return combinedList.where((d) {
    return d.name.toLowerCase().contains(lowerQuery) || 
           d.category.toLowerCase().contains(lowerQuery) ||
           d.location.toLowerCase().contains(lowerQuery);
  }).toList();
});

final nearbyDestinationsProvider = FutureProvider.family<List<Destination>, ({double lat, double lon})>((ref, coords) async {
  final overpassService = ref.watch(overpassServiceProvider);
  return overpassService.getNearbyPlaces(lat: coords.lat, lon: coords.lon);
});

// Daftarkan Service baru
final googlePlacesServiceProvider = Provider((ref) => GooglePlacesService(ref.watch(dioProvider)));
final tripAdvisorServiceProvider = Provider((ref) => TripAdvisorService(ref.watch(dioProvider)));

// Provider untuk mengambil data HOTEL dari Google
final googleHotelsProvider = FutureProvider.family<List<Destination>, ({double lat, double lon})>((ref, coords) async {
  final service = ref.watch(googlePlacesServiceProvider);
  return service.getNearbyPlaces(
    lat: coords.lat, 
    lon: coords.lon, 
    type: 'lodging', 
    categoryName: 'Hotel'
  );
});

// Provider untuk mengambil data WISATA dari Google
final googleWisataProvider = FutureProvider.family<List<Destination>, ({double lat, double lon})>((ref, coords) async {
  final service = ref.watch(googlePlacesServiceProvider);
  return service.getNearbyPlaces(
    lat: coords.lat, 
    lon: coords.lon, 
    type: 'tourist_attraction', 
    categoryName: 'Wisata'
  );
});

// Provider untuk mengambil data CAFE dari Google
final googleCafeProvider = FutureProvider.family<List<Destination>, ({double lat, double lon})>((ref, coords) async {
  final service = ref.watch(googlePlacesServiceProvider);
  return service.getNearbyPlaces(
    lat: coords.lat, 
    lon: coords.lon, 
    type: 'cafe', 
    categoryName: 'Cafe'
  );
});

// Provider untuk mengambil data BELANJA dari Google
final googleShopProvider = FutureProvider.family<List<Destination>, ({double lat, double lon})>((ref, coords) async {
  final service = ref.watch(googlePlacesServiceProvider);
  return service.getNearbyPlaces(
    lat: coords.lat, 
    lon: coords.lon, 
    type: 'shopping_mall', 
    categoryName: 'Belanja'
  );
});

// Provider untuk TripAdvisor (berdasarkan query teks)
final tripAdvisorHotelsProvider = FutureProvider.family<List<Destination>, String>((ref, query) async {
  final service = ref.watch(tripAdvisorServiceProvider);
  return service.searchHotels(query);
});
