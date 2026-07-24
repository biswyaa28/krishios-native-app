import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Abstraction for Speech Synthesis (Text-to-Speech) engines.
abstract class SpeechSynthesizer {
  Future<void> initialize({
    required VoidCallback onStart,
    required VoidCallback onComplete,
    required Function(String error) onError,
  });

  Future<void> speak(
    String text,
    String localeId, {
    required double rate,
    required double pitch,
  });

  Future<void> stop();

  bool get isSpeaking;
}

/// Concrete implementation of [SpeechSynthesizer] utilizing the flutter_tts package.
class FlutterTtsSynthesizer implements SpeechSynthesizer {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  @override
  Future<void> initialize({
    required VoidCallback onStart,
    required VoidCallback onComplete,
    required Function(String error) onError,
  }) async {
    _tts.setStartHandler(() {
      _isSpeaking = true;
      onStart();
    });
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete();
    });
    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      onError(msg.toString());
    });
    // Default setup
    await _tts.setVolume(1.0);
  }

  @override
  Future<void> speak(
    String text,
    String localeId, {
    required double rate,
    required double pitch,
  }) async {
    try {
      await _tts.setLanguage(localeId);
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);

      // Clean text of markdown formatters
      final cleanText = text
          .replaceAll(RegExp(r'\*|_|#|`'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      if (cleanText.isNotEmpty) {
        await _tts.speak(cleanText);
      } else {
        // Trigger completion manually if empty text
        _isSpeaking = false;
      }
    } catch (e) {
      debugPrint('[FlutterTtsSynthesizer] Speak error: $e');
      _isSpeaking = false;
    }
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  @override
  bool get isSpeaking => _isSpeaking;
}
