import 'package:dio/dio.dart';
import '../../domain/entities/destination.dart';

class TripAdvisorService {
  final Dio _dio;
  final String _apiKey = 'YOUR_RAPIDAPI_KEY';

  TripAdvisorService(this._dio);

  Future<List<Destination>> searchHotels(String query) async {
    try {
      final response = await _dio.get(
        'https://tripadvisor16.p.rapidapi.com/api/v1/hotels/searchLocation',
        queryParameters: {'query': query},
        options: Options(headers: {
          'X-RapidAPI-Key': _apiKey,
          'X-RapidAPI-Host': 'tripadvisor16.p.rapidapi.com',
        }),
      );

      final List data = response.data['data'] ?? [];
      return data.map((item) => Destination(
        id: item['locationId'].toString(),
        name: item['name'] ?? 'Hotel',
        category: 'Hotel',
        imageUrl: item['image_url'] ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        location: item['address'] ?? '',
        rating: double.tryParse(item['rating'] ?? '4.0') ?? 4.0,
      )).toList();
    } catch (e) {
      return [];
    }
  }
}
