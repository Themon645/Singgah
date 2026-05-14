import 'package:hive/hive.dart';
import 'package:singgah/features/destination/domain/entities/destination.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
enum TripStatus { 
  @HiveField(0)
  upcoming, 
  @HiveField(1)
  ongoing, 
  @HiveField(2)
  finished 
}

@HiveType(typeId: 1)
class Trip extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String origin;
  
  @HiveField(3)
  final String destination;
  
  @HiveField(4)
  final DateTime startDate;
  
  @HiveField(5)
  final DateTime endDate;
  
  @HiveField(6)
  final String vehicleType;
  
  @HiveField(7)
  final TripStatus status;
  
  @HiveField(8)
  final double progress;
  
  @HiveField(9)
  final List<Destination> itinerary;

  @HiveField(10)
  final Destination? hotel;

  Trip({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.vehicleType,
    this.status = TripStatus.upcoming,
    this.progress = 0.0,
    this.itinerary = const [],
    this.hotel,
  });

  Trip copyWith({
    String? id,
    String? name,
    String? origin,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? vehicleType,
    TripStatus? status,
    double? progress,
    List<Destination>? itinerary,
    Destination? hotel,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      itinerary: itinerary ?? this.itinerary,
      hotel: hotel ?? this.hotel,
    );
  }
}
