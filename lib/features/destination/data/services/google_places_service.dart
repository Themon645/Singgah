import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/destination.dart';

class GooglePlacesService {
  final Dio _dio;
  final String _apiKey = dotenv.get('GOOGLE_PLACES_API_KEY', fallback: '');

  GooglePlacesService(this._dio);

  Future<List<Destination>> getNearbyPlaces({
    required double lat,
    required double lon,
    required String type, // 'lodging' for hotels, 'tourist_attraction' for wisata
    required String categoryName,
  }) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '$lat,$lon',
          'radius': '5000',
          'type': type,
          'key': _apiKey,
        },
      );

      if (response.data['status'] != 'OK' && response.data['status'] != 'ZERO_RESULTS') {
        debugPrint('Google API Error Status: ${response.data['status']} - ${response.data['error_message']}');
      }

      final List results = response.data['results'] ?? [];
      return results.map((place) {
        final String placeId = place['place_id'] ?? '';
        
        // 1. Ambil Foto Asli dari Google dengan Fallback Unik
        String imageUrl = 'https://loremflickr.com/800/600/${categoryName.toLowerCase()}?lock=${placeId.hashCode}';
        if (place['photos'] != null && (place['photos'] as List).isNotEmpty) {
          final photoRef = place['photos'][0]['photo_reference'];
          imageUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=$photoRef&key=$_apiKey';
        }

        // 2. Ambil Rating (Gunakan random minimal agar tidak seragam 4.5)
        double rating = (place['rating'] as num?)?.toDouble() ?? (4.0 + (placeId.hashCode % 10) / 10);
        
        // 3. Ambil Lokasi yang lebih rapi (Vicinity)
        String location = place['vicinity'] ?? 'Alamat tidak tersedia';
        if (location.length > 40) location = '${location.substring(0, 37)}...';

        return Destination(
          id: place['place_id'],
          name: place['name'] ?? 'Tempat Tanpa Nama',
          category: categoryName,
          imageUrl: imageUrl,
          location: location,
          rating: rating,
          latitude: (place['geometry']['location']['lat'] as num).toDouble(),
          longitude: (place['geometry']['location']['lng'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      if (e is DioException) {
        debugPrint('Network Error: Pastikan tidak ada blokir CORS (jika di Web) atau cek koneksi internet.');
      } else {
        debugPrint('GooglePlacesService Error: $e');
      }
      return [];
    }
  }
}
