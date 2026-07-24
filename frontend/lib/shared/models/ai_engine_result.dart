class AIEngineResult {
  final String prediction;
  final double confidence;
  final double? healthScore;
  final Map<String, dynamic>? metadata;
  final String? errorMessage;
  final bool success;

  AIEngineResult({
    required this.prediction,
    required this.confidence,
    this.healthScore,
    this.metadata,
    this.errorMessage,
    this.success = true,
  });

  factory AIEngineResult.failure(String message) {
    return AIEngineResult(
      prediction: 'Unknown',
      confidence: 0.0,
      errorMessage: message,
      success: false,
    );
  }
}
