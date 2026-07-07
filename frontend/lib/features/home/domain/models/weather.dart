class Weather {
  final double temperature;
  final int humidity;
  final double precipitation;
  final double windSpeed;
  final String windDirection;
  final int weatherCode;
  final String location;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
    this.location = 'Current Location',
  });

  String get weatherDescription {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 3) return 'Mainly clear';
    if (weatherCode <= 48) return 'Foggy';
    if (weatherCode <= 57) return 'Drizzle';
    if (weatherCode <= 67) return 'Rain';
    if (weatherCode <= 77) return 'Snow';
    if (weatherCode <= 82) return 'Rain showers';
    if (weatherCode <= 86) return 'Snow showers';
    return 'Thunderstorm';
  }
}
