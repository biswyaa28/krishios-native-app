import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/models/chat_message.dart';
import 'package:krishios/shared/services/kavya/kavya_service.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;

  ChatHistoryNotifier(this._ref, String initialLang) : super([]) {
    _initWelcome(initialLang);
  }

  void _initWelcome(String langCode) {
    state = [
      ChatMessage(
        text: TranslationService.translate('chat_welcome', langCode),
        isUser: false,
        timestamp: DateTime.now(),
      )
    ];
  }

  Future<void> sendMessage({
    required String query,
    required String scanId,
    required String languageCode,
  }) async {
    // Add user message
    final userMsg = ChatMessage(
      text: query,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, userMsg];

    // Fetch and append assistant response via KavyaService orchestrator
    final kavyaService = _ref.read(kavyaServiceProvider);
    final responseMsg = await kavyaService.getResponse(
      query: query,
      scanId: scanId,
      languageCode: languageCode,
    );

    state = [...state, responseMsg];
  }

  void appendMessage(ChatMessage msg) {
    state = [...state, msg];
  }

  void clear(String langCode) {
    _initWelcome(langCode);
  }
}

// Family provider to maintain unique chat sessions per crop scan ID
final chatHistoryProvider = StateNotifierProvider.family<ChatHistoryNotifier, List<ChatMessage>, String>((ref, scanId) {
  final activeLang = ref.watch(languageProvider);
  return ChatHistoryNotifier(ref, activeLang);
});
