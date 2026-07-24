import '../../models/disease_metadata.dart';
import '../../models/agronomy_recommendation.dart';

class SoilEvaluator {
  const SoilEvaluator();

  List<AgronomyRecommendationItem> evaluate({
    required DiseaseMetadata disease,
    required String soilType,
  }) {
    final list = <AgronomyRecommendationItem>[];
    final isHealthy = disease.diseaseName.toLowerCase().contains('healthy');

    if (soilType.toLowerCase() == 'clay') {
      list.add(AgronomyRecommendationItem(
        title: 'Restrict Clay Irrigation Frequency',
        description: 'Decrease watering intervals. Ensure soil surface dries between watering events to avoid root asphyxiation.',
        priority: isHealthy ? RecommendationPriority.low : RecommendationPriority.high,
        timeline: TimelineCategory.weeklyMonitoring,
        justifications: [
          'Selected soil type is Clay, which has high water retention and low aeration indexes.',
          if (!isHealthy) 'Damp root zones promote mycelial spore translocation from soil up the stem.'
        ],
      ));
    } else if (soilType.toLowerCase() == 'sandy') {
      list.add(AgronomyRecommendationItem(
        title: 'Apply Slow-Release Nutrients & Mulch',
        description: 'Use slow-release organic NPK composts instead of liquid fertilizers, and mulch beds immediately.',
        priority: RecommendationPriority.medium,
        timeline: TimelineCategory.within48Hours,
        justifications: [
          'Selected soil type is Sandy, which suffers from high leaching and poor water retention.',
          'Frequent, small-dose fertilizations are required to maintain nutrient bioavailability.'
        ],
      ));
    } else {
      // Loamy default
      list.add(AgronomyRecommendationItem(
        title: 'Standard Loam Maintenance',
        description: 'Apply organic compost top-dressing. Maintain standard drip schedules.',
        priority: RecommendationPriority.low,
        timeline: TimelineCategory.weeklyMonitoring,
        justifications: [
          'Selected soil type is Loam, which provides balanced drainage, mineral retention, and aeration.'
        ],
      ));
    }

    return list;
  }
}
