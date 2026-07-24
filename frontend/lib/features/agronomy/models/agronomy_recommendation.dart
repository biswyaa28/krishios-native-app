enum RecommendationPriority {
  critical,
  high,
  medium,
  low
}

enum TimelineCategory {
  immediate,
  today,
  within48Hours,
  weeklyMonitoring
}

class AgronomyRecommendationItem {
  final String title;
  final String description;
  final RecommendationPriority priority;
  final TimelineCategory timeline;
  final List<String> justifications;

  const AgronomyRecommendationItem({
    required this.title,
    required this.description,
    required this.priority,
    required this.timeline,
    required this.justifications,
  });
}

class AgronomyRecommendation {
  final String severity;
  final String riskLevel;
  final List<AgronomyRecommendationItem> items;
  final String expectedRecovery;
  final String monitoringSchedule;
  final String references;

  const AgronomyRecommendation({
    required this.severity,
    required this.riskLevel,
    required this.items,
    required this.expectedRecovery,
    required this.monitoringSchedule,
    required this.references,
  });
}
