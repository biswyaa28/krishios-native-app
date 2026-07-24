import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'speech_recognition_service.dart';
import 'speech_synthesis_service.dart';
import 'voice_settings.dart';

enum VoiceState { ready, listening, thinking, speaking, permissionRequired, disabled }

final speechRecognizerProvider = Provider<SpeechRecognizer>((ref) {
  return SpeechToTextRecognizer();
});

final speechSynthesizerProvider = Provider<SpeechSynthesizer>((ref) {
  return FlutterTtsSynthesizer();
});

class VoiceService extends StateNotifier<VoiceState> {
  final Ref _ref;
  final SpeechRecognizer _recognizer;
  final SpeechSynthesizer _synthesizer;

  bool _isInitialized = false;
  Timer? _silenceTimer;
  Function(String)? _onResultCallback;
  String _currentLanguageCode = 'en';

  VoiceService(this._ref, this._recognizer, this._synthesizer)
      : super(VoiceState.ready) {
    _initTtsCallbacks();
  }

  void setContinuousMode(bool value) {
    _ref.read(voiceSettingsProvider.notifier).updateContinuousMode(value);
    if (!value) {
      stopListening();
      stopSpeaking();
    }
  }

  void _initTtsCallbacks() {
    _synthesizer.initialize(
      onStart: () {
        state = VoiceState.speaking;
        _cancelSilenceTimer();
      },
      onComplete: () {
        state = VoiceState.ready;
        // If continuous mode is enabled, wait a brief moment and auto-trigger listening
        final isContinuous = _ref.read(voiceSettingsProvider).continuousMode;
        if (isContinuous && _onResultCallback != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (state == VoiceState.ready) {
              startListening(
                languageCode: _currentLanguageCode,
                onResult: _onResultCallback!,
              );
            }
          });
        }
      },
      onError: (err) {
        debugPrint('[VoiceService] TTS Error: $err');
        state = VoiceState.ready;
      },
    );
  }

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final speechInit = await _recognizer.initialize(
        onError: (err) {
          debugPrint('[VoiceService] Speech Recognition Error: $err');
          state = VoiceState.ready;
        },
        onStatus: (status) {
          debugPrint('[VoiceService] Speech Recognition Status: $status');
          if (status == 'notListening' && state == VoiceState.listening) {
            state = VoiceState.ready;
          }
        },
      );
      if (speechInit) {
        _isInitialized = true;
      } else {
        state = VoiceState.disabled;
      }
    } catch (e) {
      debugPrint('[VoiceService] Initialization failed: $e');
      state = VoiceState.disabled;
    }
  }

  Future<bool> checkPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;

    final requestResult = await Permission.microphone.request();
    if (requestResult.isGranted) return true;

    state = VoiceState.permissionRequired;
    return false;
  }

  Future<void> startListening({
    required String languageCode,
    required Function(String) onResult,
  }) async {
    _currentLanguageCode = languageCode;
    _onResultCallback = onResult;

    final hasPermission = await checkPermission();
    if (!hasPermission) return;

    final settings = _ref.read(voiceSettingsProvider);
    if (!settings.voiceEnabled) {
      state = VoiceState.disabled;
      return;
    }

    await init();
    if (!_isInitialized) return;

    await stopSpeaking();
    state = VoiceState.listening;

    String localeId = 'en_US';
    switch (languageCode) {
      case 'hi':
        localeId = 'hi_IN';
        break;
      case 'te':
        localeId = 'te_IN';
        break;
      case 'ta':
        localeId = 'ta_IN';
        break;
      case 'kn':
        localeId = 'kn_IN';
        break;
      case 'mr':
        localeId = 'mr_IN';
        break;
      case 'bn':
        localeId = 'bn_IN';
        break;
      case 'gu':
        localeId = 'gu_IN';
        break;
      case 'pa':
        localeId = 'pa_IN';
        break;
    }

    _startSilenceTimer();

    try {
      await _recognizer.startListening(
        localeId: localeId,
        onResult: (text, isFinal) {
          _cancelSilenceTimer();
          if (text.trim().isNotEmpty) {
            if (isFinal) {
              state = VoiceState.thinking;
              Future.microtask(() {
                onResult(text);
              });
            }
          }
        },
        onSilence: () {
          _handleSilenceTimeout();
        },
      );
    } catch (_) {
      state = VoiceState.ready;
    }
  }

  Future<void> stopListening() async {
    _cancelSilenceTimer();
    await _recognizer.stopListening();
    state = VoiceState.ready;
  }

  Future<void> speak(String text, String languageCode) async {
    _currentLanguageCode = languageCode;
    final settings = _ref.read(voiceSettingsProvider);
    if (!settings.voiceEnabled || !settings.autoSpeak) {
      return;
    }

    await stopSpeaking();
    await stopListening();

    String localeId = 'en-US';
    switch (languageCode) {
      case 'hi':
        localeId = 'hi-IN';
        break;
      case 'te':
        localeId = 'te-IN';
        break;
      case 'ta':
        localeId = 'ta-IN';
        break;
      case 'kn':
        localeId = 'kn-IN';
        break;
      case 'mr':
        localeId = 'mr-IN';
        break;
      case 'bn':
        localeId = 'bn-IN';
        break;
      case 'gu':
        localeId = 'gu-IN';
        break;
      case 'pa':
        localeId = 'pa-IN';
        break;
    }

    try {
      await _synthesizer.speak(
        text,
        localeId,
        rate: settings.speechSpeed,
        pitch: settings.speechPitch,
      );
    } catch (_) {
      state = VoiceState.ready;
    }
  }

  Future<void> stopSpeaking() async {
    await _synthesizer.stop();
    state = VoiceState.ready;
  }

  void setThinking() {
    state = VoiceState.thinking;
  }

  void setReady() {
    state = VoiceState.ready;
  }

  void _startSilenceTimer() {
    _cancelSilenceTimer();
    _silenceTimer = Timer(const Duration(seconds: 8), () {
      _handleSilenceTimeout();
    });
  }

  void _cancelSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
  }

  void _handleSilenceTimeout() {
    if (state == VoiceState.listening) {
      stopListening();
      // If continuous conversation was active and user didn't speak, go back to ready
      debugPrint('[VoiceService] Silence timeout triggered.');
    }
  }

  @override
  void dispose() {
    _cancelSilenceTimer();
    super.dispose();
  }
}

final voiceServiceProvider = StateNotifierProvider<VoiceService, VoiceState>((ref) {
  final recognizer = ref.watch(speechRecognizerProvider);
  final synthesizer = ref.watch(speechSynthesizerProvider);
  return VoiceService(ref, recognizer, synthesizer);
});
