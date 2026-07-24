import '../../models/disease_metadata.dart';
import '../../../../shared/models/weather.dart';

abstract class ISeverityEstimator {
  String estimateSeverity({
    required DiseaseMetadata disease,
    required double confidence,
    required double healthScore,
    required Weather? weather,
  });
}

class HeuristicSeverityEstimator implements ISeverityEstimator {
  const HeuristicSeverityEstimator();

  @override
  String estimateSeverity({
    required DiseaseMetadata disease,
    required double confidence,
    required double healthScore,
    required Weather? weather,
  }) {
    if (disease.diseaseName.toLowerCase().contains('healthy')) {
      return 'None';
    }

    double score = 0.0;

    // 1. Low health score indicates severe tissue destruction
    if (healthScore < 30) {
      score += 4.0;
    } else if (healthScore < 60) {
      score += 2.0;
    }

    // 2. High confirmation confidence
    if (confidence > 0.85) {
      score += 3.0;
    } else if (confidence > 0.60) {
      score += 1.0;
    }

    // 3. Environmental triggers (high humidity supports fungal/bacterial expansion)
    if (weather != null && weather.humidity >= disease.humidityThreshold) {
      score += 3.0;
    }

    if (score >= 7.0) {
      return 'High';
    } else if (score >= 4.0) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }
}
