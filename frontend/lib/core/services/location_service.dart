import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String? locationName;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.locationName,
  });
}

class LocationService {
  static const _defaultLat = 25.6;
  static const _defaultLng = 85.1;

  Future<LocationResult> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final granted = await Geolocator.requestPermission();
        if (granted == LocationPermission.denied ||
            granted == LocationPermission.deniedForever) {
          return _defaultResult();
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        if (placemark.isoCountryCode == 'US') {
          return _defaultResult();
        }
        return LocationResult(
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: _formatPlacemark(placemark),
        );
      }

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return _defaultResult();
    }
  }

  String? _formatPlacemark(Placemark placemark) {
    return placemark.locality ??
        placemark.subAdministrativeArea ??
        placemark.administrativeArea;
  }

  LocationResult _defaultResult() {
    return LocationResult(
      latitude: _defaultLat,
      longitude: _defaultLng,
      locationName: 'Bihar',
    );
  }
}
