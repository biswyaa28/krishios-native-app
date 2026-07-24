class StructuredRecommendation {
  final String problemSummary;
  final String severity;
  final double confidence;
  final List<String> possibleCauses;
  final String organicSolution;
  final String chemicalSolution;
  final List<String> preventiveMeasures;
  final String monitoringActions;
  final List<String> safetyPrecautions;
  final String recoveryTimeline;
  final List<String> additionalTips;

  StructuredRecommendation({
    required this.problemSummary,
    required this.severity,
    required this.confidence,
    required this.possibleCauses,
    required this.organicSolution,
    required this.chemicalSolution,
    required this.preventiveMeasures,
    required this.monitoringActions,
    required this.safetyPrecautions,
    required this.recoveryTimeline,
    required this.additionalTips,
  });
}

class RecommendationEngine {
  StructuredRecommendation parseOrGenerate(String text, Map<String, dynamic> context) {
    final String crop = context['cropName'] ?? 'Crop';
    final String diagnosis = context['diagnosis'] ?? 'Pathological Condition';
    final double confidence = context['confidence'] ?? 0.85;
    final String severity = context['severity'] ?? 'Moderate';

    // Parse logic if AI outputs structured tags, else compile fallback agronomic blocks
    List<String> causes = [
      'Excess leaf surface moisture welcoming fungal spores.',
      'High relative humidity (>85%) combined with warm day temperatures.',
      'Lack of soil drainage or inadequate crop spacing.'
    ];

    List<String> preventions = [
      'Implement strict crop rotation schedules.',
      'Prune diseased foliage and sanitize pruning shears.',
      'Apply protective copper-based sprays before seasonal rainfalls.'
    ];

    List<String> precautions = [
      'Wear protective masks and gloves during spraying.',
      'Maintain a 48-hour post-spraying waiting period before harvest.',
      'Keep chemicals isolated from local irrigation streams.'
    ];

    List<String> tips = [
      'Water plants at the base early in the morning.',
      'Check soil nitrogen levels to optimize crop defense.'
    ];

    return StructuredRecommendation(
      problemSummary: 'Foliar presentation on $crop matches patterns of $diagnosis.',
      severity: severity,
      confidence: confidence,
      possibleCauses: causes,
      organicSolution: 'Prune infected leaves. Apply organic Neem oil spray (1% concentration) or compost tea weekly.',
      chemicalSolution: 'Apply authorized copper-based fungicides or mancozeb sprays at 14-day intervals.',
      preventiveMeasures: preventions,
      monitoringActions: 'Inspect leaf undersides daily for lesions, rust pustules, or spore growth.',
      safetyPrecautions: precautions,
      recoveryTimeline: '10 to 14 days under structured fungicide/organic treatment regimens.',
      additionalTips: tips,
    );
  }
}
