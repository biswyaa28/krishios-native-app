import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:krishios/core/constants/api_constants.dart';
import 'package:krishios/shared/models/weather.dart';
import 'package:krishios/shared/models/weather_forecast.dart';
import '../../data/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final repo = WeatherRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final locationNameProvider = StateProvider<String?>((ref) => null);

final positionProvider = FutureProvider<Position?>((ref) async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ref.read(locationNameProvider.notifier).state = ApiConstants.fallbackLocationName;
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ref.read(locationNameProvider.notifier).state = ApiConstants.fallbackLocationName;
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ref.read(locationNameProvider.notifier).state = ApiConstants.fallbackLocationName;
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );

    if (kIsWeb) {
      // Web reverse geocoding using OpenStreetMap Nominatim REST API
      try {
        final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json',
        );
        final response = await http.get(uri, headers: {'User-Agent': 'KrishiOS-Web/1.0'});
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final address = data['address'] as Map<String, dynamic>?;
          if (address != null) {
            final city = address['city'] ?? address['town'] ?? address['suburb'] ?? address['county'] ?? address['state_district'] ?? '';
            final state = address['state'] ?? '';
            if (city.isNotEmpty && state.isNotEmpty) {
              ref.read(locationNameProvider.notifier).state = '$city, $state';
              return pos;
            } else if (city.isNotEmpty) {
              ref.read(locationNameProvider.notifier).state = city.toString();
              return pos;
            }
          }
        }
      } catch (_) {}
      
      final lat = pos.latitude.toStringAsFixed(2);
      final lon = pos.longitude.toStringAsFixed(2);
      ref.read(locationNameProvider.notifier).state = 'Field Location ($lat°, $lon°)';
      return pos;
    }

    // Native Mobile reverse geocoding
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final pm = placemarks.first;
        final city = pm.locality ?? pm.subAdministrativeArea ?? '';
        final state = pm.administrativeArea ?? '';
        if (city.isNotEmpty) {
          ref.read(locationNameProvider.notifier).state = '$city, $state';
        } else {
          ref.read(locationNameProvider.notifier).state = state;
        }
      }
    } catch (_) {
      ref.read(locationNameProvider.notifier).state = 'My Farm';
    }
    return pos;
  } catch (_) {
    ref.read(locationNameProvider.notifier).state = ApiConstants.fallbackLocationName;
    return null;
  }
});

final weatherProvider = FutureProvider<Weather?>((ref) async {
  final pos = await ref.watch(positionProvider.future);
  final repo = ref.read(weatherRepositoryProvider);

  if (pos != null) {
    return repo.fetchCurrentConditions(latitude: pos.latitude, longitude: pos.longitude);
  }

  return repo.fetchCurrentConditions(
    latitude: ApiConstants.fallbackLatitude,
    longitude: ApiConstants.fallbackLongitude,
  );
});

final forecastProvider = FutureProvider<List<DailyForecast>>((ref) async {
  final pos = await ref.watch(positionProvider.future);
  final repo = ref.read(weatherRepositoryProvider);

  if (pos != null) {
    return repo.fetchForecast(latitude: pos.latitude, longitude: pos.longitude);
  }

  return repo.fetchForecast(
    latitude: ApiConstants.fallbackLatitude,
    longitude: ApiConstants.fallbackLongitude,
  );
});
