import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/home/domain/models/weather.dart';

class OpenMeteoService {
  final http.Client _client;

  OpenMeteoService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static String _windDirectionLabel(double degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor();
    return directions[index];
  }

  Future<Weather?> fetchCurrentConditions({
    double latitude = 25.6,
    double longitude = 85.1,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m,precipitation,'
            'wind_speed_10m,wind_direction_10m,weather_code',
        'timezone': 'auto',
      });

      final response = await _client.get(uri);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;

      return Weather(
        temperature: (current['temperature_2m'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        precipitation: (current['precipitation'] as num).toDouble(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        windDirection: _windDirectionLabel(
          (current['wind_direction_10m'] as num).toDouble(),
        ),
        weatherCode: (current['weather_code'] as num).toInt(),
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
