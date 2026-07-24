import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/services/hive_service.dart';

final hasSelectedLanguageProvider = StateProvider<bool>((ref) {
  final box = HiveService.getUserPrefsBox();
  return box.get('has_selected_language', defaultValue: false) as bool;
});

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref);
});

class LanguageNotifier extends StateNotifier<String> {
  final Ref _ref;

  LanguageNotifier(this._ref) : super(_loadLanguage());

  static String _loadLanguage() {
    final box = HiveService.getUserPrefsBox();
    return box.get('selected_language', defaultValue: 'en') as String;
  }

  void setLanguage(String langCode) {
    state = langCode;
    final box = HiveService.getUserPrefsBox();
    box.put('selected_language', langCode);
    box.put('has_selected_language', true);
    _ref.read(hasSelectedLanguageProvider.notifier).state = true;
  }
}

final debugLanguageBypassProvider = StateProvider<bool>((ref) => false);
