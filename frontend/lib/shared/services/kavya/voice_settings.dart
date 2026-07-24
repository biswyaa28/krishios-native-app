import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../hive_service.dart';

class VoiceSettingsState {
  final bool voiceEnabled;
  final bool autoSpeak;
  final bool continuousMode;
  final double speechSpeed;
  final double speechPitch;
  final String preferredVoice;
  final String voiceLanguage;

  const VoiceSettingsState({
    required this.voiceEnabled,
    required this.autoSpeak,
    required this.continuousMode,
    required this.speechSpeed,
    required this.speechPitch,
    required this.preferredVoice,
    required this.voiceLanguage,
  });

  VoiceSettingsState copyWith({
    bool? voiceEnabled,
    bool? autoSpeak,
    bool? continuousMode,
    double? speechSpeed,
    double? speechPitch,
    String? preferredVoice,
    String? voiceLanguage,
  }) {
    return VoiceSettingsState(
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      autoSpeak: autoSpeak ?? this.autoSpeak,
      continuousMode: continuousMode ?? this.continuousMode,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      speechPitch: speechPitch ?? this.speechPitch,
      preferredVoice: preferredVoice ?? this.preferredVoice,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
    );
  }
}

class VoiceSettingsNotifier extends StateNotifier<VoiceSettingsState> {
  VoiceSettingsNotifier()
      : super(const VoiceSettingsState(
          voiceEnabled: true,
          autoSpeak: true,
          continuousMode: false,
          speechSpeed: 0.45,
          speechPitch: 1.0,
          preferredVoice: '',
          voiceLanguage: 'en',
        )) {
    loadSettings();
  }

  void loadSettings() {
    try {
      final box = HiveService.getUserPrefsBox();
      state = VoiceSettingsState(
        voiceEnabled: box.get('voice_enabled', defaultValue: true) as bool,
        autoSpeak: box.get('auto_speak', defaultValue: true) as bool,
        continuousMode: box.get('continuous_mode', defaultValue: false) as bool,
        speechSpeed: (box.get('speech_speed', defaultValue: 0.45) as num).toDouble(),
        speechPitch: (box.get('speech_pitch', defaultValue: 1.0) as num).toDouble(),
        preferredVoice: box.get('preferred_voice', defaultValue: '') as String,
        voiceLanguage: box.get('voice_language', defaultValue: 'en') as String,
      );
    } catch (_) {
      // Keep defaults
    }
  }

  Future<void> updateVoiceEnabled(bool value) async {
    state = state.copyWith(voiceEnabled: value);
    await HiveService.getUserPrefsBox().put('voice_enabled', value);
  }

  Future<void> updateAutoSpeak(bool value) async {
    state = state.copyWith(autoSpeak: value);
    await HiveService.getUserPrefsBox().put('auto_speak', value);
  }

  Future<void> updateContinuousMode(bool value) async {
    state = state.copyWith(continuousMode: value);
    await HiveService.getUserPrefsBox().put('continuous_mode', value);
  }

  Future<void> updateSpeechSpeed(double value) async {
    state = state.copyWith(speechSpeed: value);
    await HiveService.getUserPrefsBox().put('speech_speed', value);
  }

  Future<void> updateSpeechPitch(double value) async {
    state = state.copyWith(speechPitch: value);
    await HiveService.getUserPrefsBox().put('speech_pitch', value);
  }

  Future<void> updatePreferredVoice(String value) async {
    state = state.copyWith(preferredVoice: value);
    await HiveService.getUserPrefsBox().put('preferred_voice', value);
  }

  Future<void> updateVoiceLanguage(String value) async {
    state = state.copyWith(voiceLanguage: value);
    await HiveService.getUserPrefsBox().put('voice_language', value);
  }
}

final voiceSettingsProvider =
    StateNotifierProvider<VoiceSettingsNotifier, VoiceSettingsState>((ref) {
  return VoiceSettingsNotifier();
});
