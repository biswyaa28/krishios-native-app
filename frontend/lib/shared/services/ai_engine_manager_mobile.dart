import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:http/http.dart' as http;
import '../models/ai_engine_result.dart';
import 'on_device_onnx_engine.dart';
import 'remote_api_engine.dart';

enum AIEngineMode {
  auto,
  forceLocal,
  forceCloud,
}

class AIEngineManager extends ChangeNotifier {
  final OnDeviceOnnxEngine _onnxEngine = OnDeviceOnnxEngine();
  final RemoteApiEngine _apiEngine;
  AIEngineMode _currentMode = AIEngineMode.auto;
  bool _apiReachable = false;
  String? _initError;

  AIEngineManager({required String scanBaseUrl, required String host})
      : _apiEngine = RemoteApiEngine(scanBaseUrl: scanBaseUrl, host: host);

  Future<void> initialize() async {
    try {
      debugPrint('[INFO] Initializing On-Device ONNX AI Engine...');
      await _onnxEngine.initialize();
      _initError = null;
      debugPrint('[SUCCESS] Local ONNX engine loaded and ready.');
    } catch (e) {
      debugPrint('[WARNING] ONNX init failed: $e');
      _initError = e.toString();
    }

    // Initialize API engine
    await _apiEngine.initialize();
    
    // Check initial API availability
    _apiReachable = await checkApiReachable();
    notifyListeners();
  }

  Future<bool> checkApiReachable() async {
    try {
      final cleanHost = _apiEngine.host.trim();
      final resolvedUrl = _apiEngine.scanBaseUrl.replaceFirst('localhost', cleanHost);
      final uri = Uri.parse(resolvedUrl).replace(path: '/health');
      final response = await http.get(uri).timeout(const Duration(milliseconds: 1500));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<AIEngineResult> processImage(dynamic imageFile) async {
    // 1. Update API reachability status
    _apiReachable = await checkApiReachable();
    notifyListeners();

    // 2. Decide engine route
    bool useCloud = false;
    if (_currentMode == AIEngineMode.forceCloud) {
      useCloud = true;
    } else if (_currentMode == AIEngineMode.forceLocal) {
      useCloud = false;
    } else {
      // Auto Mode: Use cloud if reachable, fallback to ONNX local if not
      useCloud = _apiReachable;
    }

    if (useCloud) {
      debugPrint('[ROUTE] Routing prediction request to: Cloud FastAPI');
      final result = await _apiEngine.processImage(imageFile);
      if (result.success) {
        return result;
      }
      debugPrint('[WARNING] Cloud FastAPI routing failed: ${result.errorMessage}. Retrying via local ONNX...');

      if (_onnxEngine.isReady) {
        debugPrint('[ROUTE] Routing fallback request to: Local ONNX Runtime');
        return await _onnxEngine.processImage(imageFile);
      }
      return result;
    } else {
      // Local preferred (forceLocal or auto-offline)
      if (_onnxEngine.isReady) {
        debugPrint('[ROUTE] Routing prediction request to: Local ONNX Runtime');
        return await _onnxEngine.processImage(imageFile);
      }

      // If local ONNX is not ready, fall back to cloud as a last resort (if not forced local)
      if (_currentMode != AIEngineMode.forceLocal) {
        debugPrint('[ROUTE] Routing fallback request to: Cloud FastAPI');
        return await _apiEngine.processImage(imageFile);
      }

      return AIEngineResult.failure('Local ONNX engine is not initialized.');
    }
  }

  AIEngineMode get currentMode => _currentMode;

  bool get apiReachable => _apiReachable;

  String get resolvedBaseUrl {
    final cleanHost = _apiEngine.host.trim();
    return _apiEngine.scanBaseUrl.replaceFirst('localhost', cleanHost);
  }

  void setEngineMode(AIEngineMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  bool get isUsingLocal {
    if (_currentMode == AIEngineMode.forceLocal) return true;
    if (_currentMode == AIEngineMode.forceCloud) return false;
    // Auto mode
    return !_apiReachable;
  }

  String? get initError => _initError;

  @override
  void dispose() {
    _onnxEngine.dispose();
    _apiEngine.dispose();
    super.dispose();
  }
}
