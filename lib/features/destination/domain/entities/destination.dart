import 'package:hive/hive.dart';

part 'destination.g.dart';

@HiveType(typeId: 2)
class Destination extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final String imageUrl;
  
  @HiveField(4)
  final double rating;
  
  @HiveField(5)
  final String location;
  
  @HiveField(6)
  final String? arrivalTime;
  
  @HiveField(7)
  final String? departureTime;

  @HiveField(8)
  final double? latitude;

  @HiveField(9)
  final double? longitude;

  Destination({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.rating = 0.0,
    required this.location,
    this.arrivalTime,
    this.departureTime,
    this.latitude,
    this.longitude,
  });
}
