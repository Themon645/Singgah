import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';
import 'package:singgah/features/trip/domain/entities/trip.dart';

final tripsProvider = StateNotifierProvider<TripNotifier, List<Trip>>((ref) {
  return TripNotifier();
});

class TripNotifier extends StateNotifier<List<Trip>> {
  late Box<Trip> _box;

  TripNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box<Trip>('trips_box');
    _loadTrips();
  }

  void _loadTrips() {
    try {
      if (_box.isEmpty) {
        final dummyTrips = [
          Trip(
            id: '1',
            name: 'Weekend di Bandung',
            origin: 'Jakarta',
            destination: 'Bandung',
            startDate: DateTime(2024, 3, 12),
            endDate: DateTime(2024, 3, 14),
            vehicleType: 'Mobil',
            status: TripStatus.upcoming,
            itinerary: [
              Destination(
                id: 'd1',
                name: 'Tangkuban Perahu',
                category: 'Alam',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABiuBDs55LESkKItGACIZ0Ap2IaqBMcKKwlQOLNfomWinnwUKpBF5ZppqKo3ervnrGaGj7o0ydVNz7cMlaGeGVjP06ppelAjXiFTmKXcYZQVbMuaRa1X8L7KztyeOPujuaMWJ59R7giNoowsB3EEEtc7maDZbkMgRbf9o1uxEVxcP5tONaMLgRndqMfXKmhJi1eJlbt8w9Rt2RTH6-JKkRAUSSs1bNsliOCScriVEw5MUDFT1KE9-HJXSRumvrjKJ9MyRTqtidBcc',
                location: 'Lembang, Bandung',
                latitude: -6.7596377,
                longitude: 107.5925345,
                arrivalTime: '08:30',
              ),
              Destination(
                id: 'd2',
                name: 'Lawangwangi Art',
                category: 'Seni',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQo7_HSG3eBYkqW50ytifCeGAESXoNtnSI_im9MPtww6glvtWDbg-VRWSTcTQMMgoCcCp34Ai1gV3AnUBx9EBgYSWwlqU8xzRDNdrlZYV9jygyCblpdkPOiRYufPrQq7qQG6OFb5AcjSNVw3YT9sP4cxXhRqOfdZUOHY2WUeAfuoPYnzxYzTS3ECAkU5yOShHyI7dzC6fimLr0pJLXcyc7u67awT2pHJm51Y4nmjP3lrdgOb3PIbfA-A0t4gQ3Tg7JXKzRD9XmgJ8',
                location: 'Dago, Bandung',
                latitude: -6.845585,
                longitude: 107.618685,
                arrivalTime: '11:00',
              ),
            ],
          ),
        ];
        for (var trip in dummyTrips) {
          _box.put(trip.id, trip);
        }
      }
      state = _box.values.toList();
    } catch (e) {
      debugPrint('Error loading trips: $e');
      _box.clear();
      state = [];
    }
  }

  Future<void> addTrip(Trip trip) async {
    await _box.put(trip.id, trip);
    state = _box.values.toList();
  }

  Future<void> addDestinationToTrip(String tripId, Destination destination) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final updatedItinerary = List<Destination>.from(trip.itinerary)..add(destination);
      final updatedTrip = trip.copyWith(itinerary: updatedItinerary);
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }

  Future<void> updateDestination(String tripId, String destinationId, {String? arrivalTime, String? departureTime, int? visitDay}) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final updatedItinerary = trip.itinerary.map((dest) {
        if (dest.id == destinationId) {
          return Destination(
            id: dest.id,
            name: dest.name,
            category: dest.category,
            imageUrl: dest.imageUrl,
            location: dest.location,
            rating: dest.rating,
            arrivalTime: arrivalTime ?? dest.arrivalTime,
            departureTime: departureTime ?? dest.departureTime,
            latitude: dest.latitude,
            longitude: dest.longitude,
            visitDay: visitDay ?? dest.visitDay,
          );
        }
        return dest;
      }).toList();
      
      final updatedTrip = trip.copyWith(itinerary: updatedItinerary);
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }

  Future<void> reorderItinerary(String tripId, int oldIndex, int newIndex) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final itinerary = List<Destination>.from(trip.itinerary);
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = itinerary.removeAt(oldIndex);
      itinerary.insert(newIndex, item);
      
      final updatedTrip = trip.copyWith(itinerary: itinerary);
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }

  Future<void> removeDestinationFromTrip(String tripId, String destinationId) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final updatedItinerary = trip.itinerary.where((dest) => dest.id != destinationId).toList();
      final updatedTrip = trip.copyWith(itinerary: updatedItinerary);
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }

  Future<void> removeTrip(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  Future<void> setHotelForTrip(String tripId, Destination hotel) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final updatedTrip = trip.copyWith(hotel: hotel);
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }

  Future<void> removeHotelFromTrip(String tripId) async {
    final trip = _box.get(tripId);
    if (trip != null) {
      final updatedTrip = Trip(
        id: trip.id,
        name: trip.name,
        origin: trip.origin,
        destination: trip.destination,
        startDate: trip.startDate,
        endDate: trip.endDate,
        vehicleType: trip.vehicleType,
        status: trip.status,
        progress: trip.progress,
        itinerary: trip.itinerary,
        hotel: null,
      );
      await _box.put(tripId, updatedTrip);
      state = _box.values.toList();
    }
  }
}
