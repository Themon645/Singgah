import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnsplashService {
  final Dio _dio;
  // Ini adalah Access Key publik. Untuk produksi, sebaiknya gunakan API Key Anda sendiri.
  final String _accessKey = 'YOUR_UNSPLASH_ACCESS_KEY'; 

  UnsplashService(this._dio);

  /// Mengambil satu URL gambar berdasarkan kata kunci pencarian
  Future<String> getImageUrlByQuery(String query) async {
    try {
      final response = await _dio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {
          'query': query,
          'per_page': 1,
          'orientation': 'landscape',
          'client_id': _accessKey,
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        if (results.isNotEmpty) {
          return results[0]['urls']['regular'];
        }
      }
    } catch (e) {
      // Jika error atau tidak ditemukan, gunakan placeholder yang tetap relevan
      return 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=800&auto=format&fit=crop';
    }
    return 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=800&auto=format&fit=crop';
  }
}

final unsplashServiceProvider = Provider((ref) {
  final dio = Dio(); // Bisa gunakan provider dio yang sudah ada jika mau
  return UnsplashService(dio);
});
