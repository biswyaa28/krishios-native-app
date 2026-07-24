import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../models/ai_engine_result.dart';
import 'remote_api_engine.dart';

enum AIEngineMode {
  auto,
  forceLocal,
  forceCloud,
}

class AIEngineManager extends ChangeNotifier {
  final RemoteApiEngine _apiEngine;
  AIEngineMode _currentMode = AIEngineMode.auto;
  bool _apiReachable = false;

  AIEngineManager({required String scanBaseUrl, required String host})
      : _apiEngine = RemoteApiEngine(scanBaseUrl: scanBaseUrl, host: host);

  AIEngineMode get currentMode => _currentMode;
  bool get isLocalEngineReady => false;
  bool get isApiReachable => _apiReachable;
  bool get apiReachable => _apiReachable;
  bool get isUsingLocal => false;
  String? get initError => null;
  String get resolvedBaseUrl => _apiEngine.scanBaseUrl;

  Future<void> initialize() async {
    await checkConnectivity();
  }

  Future<bool> checkConnectivity() async {
    _apiReachable = true;
    notifyListeners();
    return true;
  }

  void setEngineMode(AIEngineMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  Future<AIEngineResult> processImage(dynamic imageFile) async {
    return _apiEngine.processImage(imageFile);
  }

  Future<AIEngineResult> analyzeImage({
    required List<int> imageBytes,
    required String filename,
  }) async {
    return _apiEngine.processImage(imageBytes);
  }

  Future<AIEngineResult> analyzeCrop({
    required List<int> imageBytes,
    required String filename,
    required String cropName,
  }) async {
    return _apiEngine.processImage(imageBytes);
  }
}
