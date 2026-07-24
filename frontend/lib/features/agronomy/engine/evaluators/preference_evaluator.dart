import '../../models/disease_metadata.dart';
import '../../models/agronomy_recommendation.dart';

class PreferenceEvaluator {
  const PreferenceEvaluator();

  List<AgronomyRecommendationItem> evaluate({
    required DiseaseMetadata disease,
    required String preference,
  }) {
    final list = <AgronomyRecommendationItem>[];
    final isHealthy = disease.diseaseName.toLowerCase().contains('healthy');
    final pref = preference.toLowerCase();

    // 1. Organic Treatment Option
    if (pref == 'organic' || pref == 'mixed') {
      if (disease.organicTreatments.isNotEmpty) {
        list.add(AgronomyRecommendationItem(
          title: 'Organic Biological Control',
          description: disease.organicTreatments.join('\n'),
          priority: isHealthy ? RecommendationPriority.low : RecommendationPriority.critical,
          timeline: TimelineCategory.immediate,
          justifications: [
            'Farmer preference is set to $preference.',
            if (!isHealthy) 'Organic compounds suppress fungal pathogens without leaving synthetic residue.'
          ],
        ));
      }
    }

    // 2. Chemical Treatment Option
    if (pref == 'chemical' || pref == 'mixed') {
      if (disease.chemicalTreatments.isNotEmpty && !isHealthy) {
        list.add(AgronomyRecommendationItem(
          title: 'Chemical Fungicide / Treatment',
          description: disease.chemicalTreatments.join('\n'),
          priority: RecommendationPriority.critical,
          timeline: TimelineCategory.immediate,
          justifications: [
            'Farmer preference is set to $preference.',
            'Requires strict calibration and safety intervals prior to food harvesting.'
          ],
        ));
      }
    }

    // 3. Preventive Measures
    if (disease.preventiveMeasures.isNotEmpty) {
      list.add(AgronomyRecommendationItem(
        title: 'Agricultural Preventive Protocols',
        description: disease.preventiveMeasures.join('\n'),
        priority: RecommendationPriority.high,
        timeline: TimelineCategory.within48Hours,
        justifications: [
          'Critical steps required to arrest spore vector multiplication and isolate clean canopy zones.'
        ],
      ));
    }

    return list;
  }
}
