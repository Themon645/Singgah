import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/destination.dart';

class OverpassService {
  final Dio _dio;
  
  OverpassService(this._dio);

  Future<List<Destination>> getNearbyPlaces({
    required double lat,
    required double lon,
    double radius = 3000,
  }) async {
    const String url = 'https://overpass-api.de/api/interpreter';
    
    final query = '''
      [out:json][timeout:25];
      (
        node["amenity"~"cafe|restaurant|coffee_shop"](around:$radius, $lat, $lon);
        node["tourism"~"hotel|hostel|guest_house|attraction|museum|viewpoint"](around:$radius, $lat, $lon);
        node["leisure"~"park|garden"](around:$radius, $lat, $lon);
        node["shop"~"mall|supermarket|clothes|department_store|gift"](around:$radius, $lat, $lon);
      );
      out body;
    ''';

    try {
      final response = await _dio.post(
        url,
        data: 'data=${Uri.encodeComponent(query)}',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        final List elements = response.data['elements'] ?? [];
        return elements.map((e) {
          final tags = Map<String, dynamic>.from(e['tags'] ?? {});
          final name = tags['name'] ?? 'Tempat Tanpa Nama';
          
          String category = 'Wisata';
          String imageKeyword = 'travel';

          if (tags.containsKey('amenity')) {
            category = 'Cafe';
            imageKeyword = 'cafe,coffee';
          } else if (tags.containsKey('tourism')) {
            if (tags['tourism'] == 'hotel' || tags['tourism'] == 'hostel') {
              category = 'Hotel';
              imageKeyword = 'hotel,room';
            } else {
              category = 'Wisata';
              imageKeyword = 'landmark,nature';
            }
          } else if (tags.containsKey('shop')) {
            category = 'Belanja';
            imageKeyword = 'shopping,mall';
          }

          // Logika Lokasi Spesifik: Menarik Suburb (Daerah) dan City (Kota)
          String? suburb = tags['addr:suburb'] ?? tags['addr:neighbourhood'] ?? tags['addr:district'];
          String? city = tags['addr:city'] ?? tags['addr:province'];
          
          String locationDisplay = '';
          if (suburb != null && city != null) {
            locationDisplay = '$suburb, $city';
          } else if (city != null) {
            locationDisplay = city;
          } else if (suburb != null) {
            locationDisplay = '$suburb Area';
          } else {
            locationDisplay = 'Sekitarmu';
          }

          final imageUrl = 'https://loremflickr.com/800/600/$imageKeyword';

          return Destination(
            id: e['id'].toString(),
            name: name,
            category: category,
            imageUrl: imageUrl,
            location: locationDisplay,
            latitude: (e['lat'] as num?)?.toDouble(),
            longitude: (e['lon'] as num?)?.toDouble(),
            rating: 4.5,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

final dioProvider = Provider((ref) => Dio());
final overpassServiceProvider = Provider((ref) => OverpassService(ref.watch(dioProvider)));
