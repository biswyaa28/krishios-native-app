import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krishios/shared/models/chat_message.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/features/scan/data/treatment_data.dart';

class ChatService {
  final String resolvedBaseUrl;

  ChatService({required this.resolvedBaseUrl});

  Future<ChatMessage> sendMessage({
    required String query,
    required String cropName,
    required String diagnosis,
    required String languageCode,
    required bool isUsingLocal,
  }) async {
    if (!isUsingLocal) {
      try {
        final uri = Uri.parse(resolvedBaseUrl).replace(path: '/chat');
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'message': query,
            'crop': cropName,
            'diagnosis': diagnosis,
            'language': languageCode,
          }),
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final String reply = data['response'] ?? 'Sorry, I did not understand.';
          return ChatMessage(
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
          );
        }
      } catch (_) {
        // Fallback silently to offline mode if backend is stopped/unreachable
      }
    }

    // Offline Expert System Fallback
    final String reply = _generateOfflineReply(query, cropName, diagnosis, languageCode);
    return ChatMessage(
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  String _generateOfflineReply(String query, String cropName, String diagnosis, String langCode) {
    final String q = query.toLowerCase();
    
    // Find matching base treatment protocol
    TreatmentProtocol protocol = const TreatmentProtocol(
      directTreatment: 'Inspect plant thoroughly. Isolate if symptoms worsen.',
      preventiveMeasures: 'Maintain crop rotation and sanitize farming tools.',
      fertilizersPesticides: 'Use organic compost or follow expert local advice.',
    );

    for (final entry in treatmentMap.entries) {
      if (diagnosis.toLowerCase().contains(entry.key)) {
        protocol = entry.value;
        break;
      }
    }

    // Localize the treatment protocol and crop/disease names
    final localizedCrop = TranslationService.translateCrop(cropName, langCode);
    final localizedDisease = TranslationService.translateDisease(diagnosis, langCode);
    final localizedProtocol = TranslationService.translateTreatment(diagnosis, langCode, protocol);

    final String organicWord = TranslationService.translate('organic', langCode);
    final String chemicalWord = TranslationService.translate('chemical', langCode);

    // Determine query intent
    final bool asksOrganic = q.contains('organic') || 
                             q.contains('जैविक') || 
                             q.contains('సేంద్రీయ') || 
                             q.contains('இயற்கை') || 
                             q.contains('ಸಾವಯವ') || 
                             q.contains('सेंद्रिय') || 
                             q.contains('জৈব');

    final bool asksChemical = q.contains('chemical') || 
                              q.contains('रासायनिक') || 
                              q.contains('రసాయన') || 
                              q.contains('ரசாயனம்') || 
                              q.contains('ರಾಸಾಯನಿಕ') || 
                              q.contains('রাসায়নিক');

    final bool asksPrevention = q.contains('prevent') || 
                                q.contains('बचाव') || 
                                q.contains('నివారణ') || 
                                q.contains('தடுப்பு') || 
                                q.contains('ತಡೆಗಟ್ಟುವಿಕೆ') || 
                                q.contains('প্ৰতিরোধ');

    final bool asksCure = q.contains('cure') || 
                          q.contains('치료') || 
                          q.contains('చికిత్స') || 
                          q.contains('உபசாரம்') || 
                          q.contains('ಚಿಕಿತ್ಸೆ') || 
                          q.contains('উপচার');

    if (asksOrganic) {
      return '$organicWord:\n${localizedProtocol.directTreatment}';
    } else if (asksChemical) {
      return '$chemicalWord:\n${localizedProtocol.fertilizersPesticides}';
    } else if (asksPrevention) {
      return 'Prevention / निवारण:\n${localizedProtocol.preventiveMeasures}';
    } else if (asksCure) {
      return 'Cure / उपचार:\n${localizedProtocol.directTreatment}\n\n${localizedProtocol.fertilizersPesticides}';
    }

    // General informational greeting
    switch (langCode) {
      case 'hi':
        return 'नमस्ते! मैं आपका ऑफ़लाइन कृषिअसिस्टेंट हूँ। $localizedCrop के $localizedDisease के लिए, आप मुझसे पूछ सकते हैं:\n\n'
            '• "जैविक उपचार"\n'
            '• "रासायनिक उपचार"\n'
            '• "बचाव के उपाय"\n\n'
            'संक्षिप्त विवरण:\n'
            '• उपचार: ${localizedProtocol.directTreatment}\n'
            '• रोकथाम: ${localizedProtocol.preventiveMeasures}';
      case 'te':
        return 'నమస్కారం! నేను మీ ఆఫ్-లైన్ కృషిఅసిస్టెంట్ ని. $localizedCrop పంటకు సోకిన $localizedDisease కోసం, నన్ను అడగండి:\n\n'
            '• "సేంద్రీయ చికిత్స"\n'
            '• "రసాయన చికిత్స"\n'
            '• "నివారణ"\n\n'
            'వివరాలు:\n'
            '• చికిత్స: ${localizedProtocol.directTreatment}\n'
            '• నివారణ: ${localizedProtocol.preventiveMeasures}';
      case 'ta':
        return 'வணக்கம்! நான் உங்கள் ஆஃப்லைன் கிருஷிஅசிஸ்டெண்ட். $localizedCrop - $localizedDisease க்கு, என்னிடம் கேளுங்கள்:\n\n'
            '• "இயற்கை சிகிச்சை"\n'
            '• "ரசாயன சிகிச்சை"\n'
            '• "தடுப்பு"\n\n'
            'விவரங்கள்:\n'
            '• சிகிச்சை: ${localizedProtocol.directTreatment}\n'
            '• தடுப்பு: ${localizedProtocol.preventiveMeasures}';
      case 'kn':
        return 'ನಮಸ್ಕಾರ! ನಾನು ನಿಮ್ಮ ಆಫ್‌ಲೈನ್ ಕೃಷಿಅಸಿಸ್ಟೆಂಟ್. $localizedCrop ರ $localizedDisease ಗಾಗಿ, ಕೇಳಿ:\n\n'
            '• "ಸಾವಯವ ಚಿಕಿत्ಸೆ"\n'
            '• "ರಾಸಾಯನಿಕ ಚಿಕಿತ್ಸೆ"\n'
            '• "ತಡೆಗಟ್ಟುವಿಕೆ"\n\n'
            'ವಿವರಗಳು:\n'
            '• ಚಿಕಿತ್ಸೆ: ${localizedProtocol.directTreatment}\n'
            '• ತಡೆಗಟ್ಟುವಿಕೆ: ${localizedProtocol.preventiveMeasures}';
      case 'mr':
        return 'नमस्कार! मी तुमचा ऑफलाइन कृषीअसिस्टंट आहे. $localizedCrop पिकावरील $localizedDisease साठी, विचारा:\n\n'
            '• "सेंद्रिय उपचार"\n'
            '• "रासायनिक उपचार"\n'
            '• "बचाव"\n\n'
            'तपशील:\n'
            '• उपचार: ${localizedProtocol.directTreatment}\n'
            '• बचाव: ${localizedProtocol.preventiveMeasures}';
      case 'bn':
        return 'হ্যালো! আমি আপনার অফলাইন কৃষিঅ্যাসিস্ট্যান্ট। $localizedCrop এর $localizedDisease এর জন্য, জিজ্ঞাসা করুন:\n\n'
            '• "জৈব চিকিৎসা"\n'
            '• "রাসায়নিক চিকিৎসা"\n'
            '• "প্রতিরোধ"\n\n'
            'বিস্তারিত:\n'
            '• চিকিৎসা: ${localizedProtocol.directTreatment}\n'
            '• প্রতিরোধ: ${localizedProtocol.preventiveMeasures}';
      default:
        return 'Hello! I am your offline KrishiAssistant. For $localizedCrop $localizedDisease, you can ask me about:\n\n'
            '• "organic treatment"\n'
            '• "chemical treatment"\n'
            '• "preventive measures"\n\n'
            'Summary:\n'
            '• Direct Treatment: ${localizedProtocol.directTreatment}\n'
            '• Prevention: ${localizedProtocol.preventiveMeasures}';
    }
  }
}
