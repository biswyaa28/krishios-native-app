import '../../models/disease_metadata.dart';
import '../../models/agronomy_recommendation.dart';

class GrowthStageEvaluator {
  const GrowthStageEvaluator();

  List<AgronomyRecommendationItem> evaluate({
    required DiseaseMetadata disease,
    required String growthStage,
  }) {
    final list = <AgronomyRecommendationItem>[];
    final stage = growthStage.toLowerCase();

    if (stage == 'flowering') {
      list.add(AgronomyRecommendationItem(
        title: 'Switch to Low-Pressure Ground Drip Irrigation',
        description: 'Irrigate directly at the root zone. Avoid overhead sprinkler runs.',
        priority: RecommendationPriority.high,
        timeline: TimelineCategory.today,
        justifications: [
          'The crop is currently in the Flowering stage.',
          'Overhead spraying knocks off delicate blossoms and initiates flower rot, destroying yield potential.'
        ],
      ));
      list.add(AgronomyRecommendationItem(
        title: 'Supplement Phosphorus & Potassium',
        description: 'Apply high-phosphorus organic liquid seaweed extracts or bone meal.',
        priority: RecommendationPriority.medium,
        timeline: TimelineCategory.within48Hours,
        justifications: [
          'Flowering crops require high energy transfers supported by phosphorus, rather than vegetative nitrogen.'
        ],
      ));
    } else if (stage == 'fruiting') {
      list.add(AgronomyRecommendationItem(
        title: 'Stabilize Drip Watering & Add Calcium',
        description: 'Water at the same hour daily and supply gypsum or calcium sprays to avoid blossom-end rot.',
        priority: RecommendationPriority.high,
        timeline: TimelineCategory.immediate,
        justifications: [
          'The crop is in the active Fruiting stage.',
          'Dry-to-wet soil oscillations during fruiting cause rapid water expansion, splitting skins and opening entry wounds.'
        ],
      ));
    } else if (stage == 'vegetative') {
      list.add(AgronomyRecommendationItem(
        title: 'Build Crop Trellis Framework',
        description: 'Stake stems and train vines to standard vertical networks to elevate expanding foliage off wet soil.',
        priority: RecommendationPriority.medium,
        timeline: TimelineCategory.within48Hours,
        justifications: [
          'Vegetative shoots require support lines to prevent leaf contact with soil spore reservoirs.'
        ],
      ));
    } else if (stage == 'mature') {
      list.add(AgronomyRecommendationItem(
        title: 'Taper Off Watering & Halt Fertilizers',
        description: 'Stop all nutritional feeds. Maintain only trace root zone hydration.',
        priority: RecommendationPriority.medium,
        timeline: TimelineCategory.within48Hours,
        justifications: [
          'The crop is Mature and preparing for harvest.',
          'Excess soil moisture splits mature fruit skin and reduces storage longevity.'
        ],
      ));
    }

    return list;
  }
}
