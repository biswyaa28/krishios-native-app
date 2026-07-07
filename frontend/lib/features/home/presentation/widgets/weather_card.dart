import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/open_meteo_service.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/models/weather.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final OpenMeteoService _weatherService = OpenMeteoService();
  final LocationService _locationService = LocationService();
  Weather? _weather;
  String? _locationName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }

  Future<void> _loadWeather() async {
    final location = await _locationService.getCurrentLocation();
    final weather = await _weatherService.fetchCurrentConditions(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    if (mounted) {
      setState(() {
        _weather = weather;
        _locationName = location.locationName;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _loading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _weather == null
              ? _buildError()
              : _buildWeatherContent(),
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT CONDITIONS',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            const Icon(
              Icons.wb_cloudy_outlined,
              color: AppColors.tertiaryFixedDim,
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Unable to load weather data', style: AppTextStyles.bodySm),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => _loading = true);
            _loadWeather();
          },
          child: Text(
            'Tap to retry',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherContent() {
    final w = _weather!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT CONDITIONS',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            const Icon(
              Icons.wb_cloudy_outlined,
              color: AppColors.tertiaryFixedDim,
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${w.temperature.round()}°C',
              style: AppTextStyles.headlineLgMobile,
            ),
            const SizedBox(width: 8),
            Text(_locationName ?? w.location, style: AppTextStyles.bodySm),
          ],
        ),
        const Divider(height: 24, color: AppColors.outlineVariant),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _weatherStat(Icons.water_drop_outlined, '${w.humidity}% Humidity'),
            _weatherStat(Icons.water, '${w.precipitation.round()}% Rain'),
            _weatherStat(
              Icons.air,
              '${w.windSpeed.round()} km/h ${w.windDirection}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherStat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSm),
      ],
    );
  }
}
