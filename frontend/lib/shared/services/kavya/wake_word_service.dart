import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WakeWordService {
  bool _isListening = false;

  WakeWordService();

  bool get isListening => _isListening;

  /// Setup stub parameters for offline wake word detector (e.g. Porcupine / Snowboy)
  Future<void> startWakeWordDetector({
    required VoidCallback onWakeWordDetected,
  }) async {
    if (_isListening) return;
    _isListening = true;
    debugPrint('[WakeWordService] Hey Kavya background word monitoring initialized (Simulated).');
    
    // Background listening loops are not executed in Phase B to preserve CPU battery limits.
  }

  Future<void> stopWakeWordDetector() async {
    _isListening = false;
    debugPrint('[WakeWordService] Wake word monitoring suspended.');
  }
}

final wakeWordServiceProvider = Provider<WakeWordService>((ref) {
  return WakeWordService();
});
