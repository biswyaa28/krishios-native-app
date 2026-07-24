class DiseaseMetadata {
  final String diseaseName;
  final String scientificName;
  final String crop;
  final String symptoms;
  final String causes;
  final String spread;
  final List<String> organicTreatments;
  final List<String> chemicalTreatments;
  final List<String> preventiveMeasures;
  final String fertilizerAdvice;
  final String weatherSensitivity;
  final int humidityThreshold;
  final String temperatureRange;
  final String recoveryGuidance;
  final String references;
  final String lastReviewed;

  DiseaseMetadata({
    required this.diseaseName,
    required this.scientificName,
    required this.crop,
    required this.symptoms,
    required this.causes,
    required this.spread,
    required this.organicTreatments,
    required this.chemicalTreatments,
    required this.preventiveMeasures,
    required this.fertilizerAdvice,
    required this.weatherSensitivity,
    required this.humidityThreshold,
    required this.temperatureRange,
    required this.recoveryGuidance,
    required this.references,
    required this.lastReviewed,
  });

  factory DiseaseMetadata.fromJson(Map<String, dynamic> json) {
    return DiseaseMetadata(
      diseaseName: json['disease_name'] ?? 'Unknown Disease',
      scientificName: json['scientific_name'] ?? 'N/A',
      crop: json['crop'] ?? 'Unknown Crop',
      symptoms: json['symptoms'] ?? 'No symptom description available.',
      causes: json['causes'] ?? 'No cause descriptions found.',
      spread: json['spread'] ?? 'No spread information available.',
      organicTreatments: List<String>.from(json['organic_treatments'] ?? []),
      chemicalTreatments: List<String>.from(json['chemical_treatments'] ?? []),
      preventiveMeasures: List<String>.from(json['preventive_measures'] ?? []),
      fertilizerAdvice: json['fertilizer_advice'] ?? 'Standard fertilization recommended.',
      weatherSensitivity: json['weather_sensitivity'] ?? 'None.',
      humidityThreshold: json['humidity_threshold'] ?? 75,
      temperatureRange: json['temperature_range'] ?? 'N/A',
      recoveryGuidance: json['recovery_guidance'] ?? 'Monitor regularly.',
      references: json['references'] ?? 'General Agricultural Advisory.',
      lastReviewed: json['last_reviewed'] ?? 'N/A',
    );
  }
}
