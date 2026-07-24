import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Abstraction for Speech Recognition (Speech-to-Text) engines.
abstract class SpeechRecognizer {
  Future<bool> initialize({
    required Function(String errorMsg) onError,
    required Function(String status) onStatus,
  });

  Future<void> startListening({
    required String localeId,
    required Function(String text, bool isFinal) onResult,
    required Function() onSilence,
    Duration listenTimeout = const Duration(seconds: 8),
  });

  Future<void> stopListening();

  bool get isListening;

  Future<void> cancel();
}

/// Concrete implementation of [SpeechRecognizer] utilizing the speech_to_text package.
class SpeechToTextRecognizer implements SpeechRecognizer {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  @override
  Future<bool> initialize({
    required Function(String errorMsg) onError,
    required Function(String status) onStatus,
  }) async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (err) => onError(err.errorMsg),
        onStatus: (status) => onStatus(status),
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('[SpeechToTextRecognizer] Init failed: $e');
      return false;
    }
  }

  @override
  Future<void> startListening({
    required String localeId,
    required Function(String text, bool isFinal) onResult,
    required Function() onSilence,
    Duration listenTimeout = const Duration(seconds: 8),
  }) async {
    if (!_isInitialized) {
      debugPrint('[SpeechToTextRecognizer] Not initialized.');
      return;
    }
    await _speech.stop();
    try {
      // ignore: deprecated_member_use
      await _speech.listen(
        // ignore: deprecated_member_use
        localeId: localeId,
        onResult: (result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        // ignore: deprecated_member_use
        listenFor: listenTimeout,
        // ignore: deprecated_member_use
        pauseFor: const Duration(seconds: 3), // Silence detection
      );
    } catch (e) {
      debugPrint('[SpeechToTextRecognizer] Listen error: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<void> cancel() async {
    await _speech.cancel();
  }
}
