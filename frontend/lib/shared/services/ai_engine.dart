import '../models/ai_engine_result.dart';

abstract class AIEngine {
  Future<void> initialize();
  Future<AIEngineResult> processImage(dynamic imageFile);
  bool get isReady;
  void dispose();
}
