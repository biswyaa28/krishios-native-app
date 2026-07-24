import '../models/disease_metadata.dart';
import '../models/agronomy_recommendation.dart';
import '../../../shared/models/weather.dart';
import 'evaluators/weather_evaluator.dart';
import 'evaluators/severity_evaluator.dart';
import 'evaluators/soil_evaluator.dart';
import 'evaluators/growth_stage_evaluator.dart';
import 'evaluators/preference_evaluator.dart';

class DecisionEngine {
  final ISeverityEstimator _severityEstimator;
  final WeatherEvaluator _weatherEvaluator = const WeatherEvaluator();
  final SoilEvaluator _soilEvaluator = const SoilEvaluator();
  final GrowthStageEvaluator _growthStageEvaluator = const GrowthStageEvaluator();
  final PreferenceEvaluator _preferenceEvaluator = const PreferenceEvaluator();

  DecisionEngine({
    ISeverityEstimator severityEstimator = const HeuristicSeverityEstimator(),
  }) : _severityEstimator = severityEstimator;

  AgronomyRecommendation process({
    required DiseaseMetadata disease,
    required double confidence,
    required double healthScore,
    required Weather? weather,
    required String soilType,
    required String growthStage,
    required String preference,
  }) {
    // 1. Calculate severity via pluggable interface
    final severity = _severityEstimator.estimateSeverity(
      disease: disease,
      confidence: confidence,
      healthScore: healthScore,
      weather: weather,
    );

    final items = <AgronomyRecommendationItem>[];

    // 2. Gather outputs from modular rule evaluators
    items.addAll(_preferenceEvaluator.evaluate(disease: disease, preference: preference));
    items.addAll(_weatherEvaluator.evaluate(disease: disease, weather: weather));
    items.addAll(_soilEvaluator.evaluate(disease: disease, soilType: soilType));
    items.addAll(_growthStageEvaluator.evaluate(disease: disease, growthStage: growthStage));

    // 3. Sort recommendations by priority (critical -> high -> medium -> low)
    items.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    // 4. Construct explainable risk message
    final isHealthy = disease.diseaseName.toLowerCase().contains('healthy');
    String riskLevel = 'Stable: No pathogens active.';
    if (!isHealthy) {
      if (weather != null && weather.humidity >= disease.humidityThreshold) {
        riskLevel = 'Alert: High ambient humidity (${weather.humidity}%) matches the risk boundary for ${disease.diseaseName}.';
      } else {
        riskLevel = 'Caution: ${disease.diseaseName} confirmed. Protective isolation recommended.';
      }
    }

    return AgronomyRecommendation(
      severity: severity,
      riskLevel: riskLevel,
      items: items,
      expectedRecovery: disease.recoveryGuidance,
      monitoringSchedule: 'Perform canopy sweeps every ${severity == 'High' ? '24 hours' : (severity == 'Medium' ? '48 hours' : '72 hours')}.',
      references: '${disease.references} (Reviewed: ${disease.lastReviewed})',
    );
  }
}
