import '../../models/disease_metadata.dart';
import '../../models/agronomy_recommendation.dart';
import '../../../../shared/models/weather.dart';

class WeatherEvaluator {
  const WeatherEvaluator();

  List<AgronomyRecommendationItem> evaluate({
    required DiseaseMetadata disease,
    required Weather? weather,
  }) {
    final list = <AgronomyRecommendationItem>[];
    if (weather == null) return list;

    final isHealthy = disease.diseaseName.toLowerCase().contains('healthy');

    // Rule 1: High Humidity Trigger
    if (weather.humidity >= disease.humidityThreshold && !isHealthy) {
      list.add(AgronomyRecommendationItem(
        title: 'Increase Canopy Airflow',
        description: 'Immediately prune bottom foliage and space adjacent plants to improve dry air circulation.',
        priority: RecommendationPriority.critical,
        timeline: TimelineCategory.immediate,
        justifications: [
          'Current ambient humidity is ${weather.humidity}%, exceeding the ${disease.humidityThreshold}% risk threshold.',
          'The diagnosed pathogen (${disease.scientificName}) germinates rapidly in trapped canopy moisture.'
        ],
      ));
    }

    // Rule 2: Rain Expected / Precipitation spraying delay
    if (weather.precipitation > 2.0) {
      list.add(AgronomyRecommendationItem(
        title: 'Postpone Foliar Spraying',
        description: 'Delay any scheduled fungicide, insecticide, or nutritional foliar sprays to prevent rain wash-off.',
        priority: RecommendationPriority.high,
        timeline: TimelineCategory.today,
        justifications: [
          'Precipitation is currently ${weather.precipitation}mm.',
          'Foliar treatments require at least 4-6 hours of dry leaf surface to dry and bind effectively.'
        ],
      ));
    }

    // Rule 3: Extreme Temperature Alerts
    if (weather.temperature < 5.0) {
      list.add(AgronomyRecommendationItem(
        title: 'Deploy Frost Coverings',
        description: 'Provide row covers or apply light irrigation before dawn to insulate shallow roots from freezing.',
        priority: RecommendationPriority.critical,
        timeline: TimelineCategory.immediate,
        justifications: [
          'Current temperature is ${weather.temperature}°C, which triggers frost damage rules for vegetative tissue.'
        ],
      ));
    } else if (weather.temperature > 38.0) {
      list.add(AgronomyRecommendationItem(
        title: 'Apply Deep Root Watering & Mulch',
        description: 'Increase irrigation volume by 20% and top-dress mulch to cool soil and check transpiration stress.',
        priority: RecommendationPriority.high,
        timeline: TimelineCategory.immediate,
        justifications: [
          'Extreme temperature measured at ${weather.temperature}°C is inducing vascular water transpiring strains.'
        ],
      ));
    }

    return list;
  }
}
