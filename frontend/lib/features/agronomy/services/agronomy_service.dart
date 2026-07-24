import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/disease_metadata.dart';

final agronomyServiceProvider = Provider<AgronomyService>((ref) {
  return AgronomyService();
});

class AgronomyService {
  Map<String, DiseaseMetadata> _diseases = {};
  bool _loaded = false;

  AgronomyService();

  Future<void> loadKnowledgeBase() async {
    if (_loaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/agronomy/diseases.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final diseaseMap = data['diseases'] as Map<String, dynamic>;

      _diseases = diseaseMap.map((key, val) =>
          MapEntry(key.toLowerCase().trim(), DiseaseMetadata.fromJson(val as Map<String, dynamic>)));
      _loaded = true;
    } catch (e) {
      debugPrint('[ERROR] Failed to load agronomy knowledge base: $e');
    }
  }

  DiseaseMetadata lookup(String diagnosis) {
    final cleanQuery = diagnosis.toLowerCase().trim();

    // 1. Try exact matches first
    if (_diseases.containsKey(cleanQuery)) {
      return _diseases[cleanQuery]!;
    }

    // 2. Fallback to fuzzy substring checks
    for (final entry in _diseases.entries) {
      if (cleanQuery.contains(entry.key) || entry.key.contains(cleanQuery)) {
        return entry.value;
      }
    }

    // 3. Fallback record for undocumented pathologies
    return DiseaseMetadata(
      diseaseName: diagnosis,
      scientificName: 'N/A',
      crop: 'Unknown Crop',
      symptoms: 'No detailed symptoms profile documented in database for $diagnosis.',
      causes: 'Pathology parameters not found in local library.',
      spread: 'Transmission vectors not documented.',
      organicTreatments: ['Perform baseline crop watering and isolate if symptoms worsen.'],
      chemicalTreatments: ['Chemical pesticide selections require local extension service consultation.'],
      preventiveMeasures: ['Isolate crop rows and sanitize pruning tools between contacts.'],
      fertilizerAdvice: 'Standard organic NPK top-dressing.',
      weatherSensitivity: 'Unknown.',
      humidityThreshold: 75,
      temperatureRange: 'N/A',
      recoveryGuidance: 'Monitor crop daily. Expected recovery window is unknown.',
      references: 'ICAR General Horticultural Advisories',
      lastReviewed: '2026-07-17',
    );
  }
}
