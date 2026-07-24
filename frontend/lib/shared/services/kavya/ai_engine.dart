import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:krishios/shared/models/chat_message.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/features/scan/data/treatment_data.dart';

abstract class AIEngine {
  Future<ChatMessage> sendMessage({
    required String query,
    required Map<String, dynamic> context,
    required String languageCode,
  });
}

class RuleEngine implements AIEngine {
  @override
  Future<ChatMessage> sendMessage({
    required String query,
    required Map<String, dynamic> context,
    required String languageCode,
  }) async {
    // Basic agricultural heuristic fallbacks
    final response = _generateFallbackReply(query, context, languageCode);
    return ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  String _generateFallbackReply(String query, Map<String, dynamic> context, String langCode) {
    final q = query.toLowerCase();
    final String crop = context['cropName'] ?? 'General';
    final String diagnosis = context['diagnosis'] ?? 'General';

    if (q.contains('hello') || q.contains('hi') || q.contains('hey')) {
      return TranslationService.translate('chat_welcome', langCode);
    }
    
    return 'For $crop presenting symptoms of $diagnosis, ensure optimal soil hydration. If symptoms persist, isolate the crop and inspect for pest vectors.';
  }
}

class OfflineKnowledgeEngine implements AIEngine {
  Map<String, dynamic>? _personality;
  Map<String, dynamic>? _greetings;
  Map<String, dynamic>? _timeContext;
  Map<String, dynamic>? _identity;
  Map<String, dynamic>? _systemPrompt;
  Map<String, dynamic>? _conversationRules;
  Map<String, dynamic>? _appHelp;
  Map<String, dynamic>? _aiConfig;
  Map<String, dynamic>? _agriculture;
  Map<String, dynamic>? _crops;
  Map<String, dynamic>? _diseases;
  Map<String, dynamic>? _smalltalk;

  Future<void> _ensureLoaded() async {
    if (_personality != null) return;
    try {
      final pStr = await rootBundle.loadString('assets/ai/personality/personality.json');
      _personality = json.decode(pStr);

      final gStr = await rootBundle.loadString('assets/ai/personality/greetings.json');
      _greetings = json.decode(gStr);

      final tcStr = await rootBundle.loadString('assets/ai/personality/time_context.json');
      _timeContext = json.decode(tcStr);

      final idStr = await rootBundle.loadString('assets/ai/personality/identity.json');
      _identity = json.decode(idStr);

      final sysStr = await rootBundle.loadString('assets/ai/prompts/system_prompt.json');
      _systemPrompt = json.decode(sysStr);

      final rulesStr = await rootBundle.loadString('assets/ai/personality/conversation_rules.json');
      _conversationRules = json.decode(rulesStr);

      final helpStr = await rootBundle.loadString('assets/ai/knowledge/app_help.json');
      _appHelp = json.decode(helpStr);

      final cfgStr = await rootBundle.loadString('assets/ai/settings/ai_config.json');
      _aiConfig = json.decode(cfgStr);

      final agStr = await rootBundle.loadString('assets/ai/knowledge/agriculture.json');
      _agriculture = json.decode(agStr);

      final cropsStr = await rootBundle.loadString('assets/ai/knowledge/crops.json');
      _crops = json.decode(cropsStr);

      final disStr = await rootBundle.loadString('assets/ai/knowledge/diseases.json');
      _diseases = json.decode(disStr);

      final stStr = await rootBundle.loadString('assets/ai/personality/smalltalk.json');
      _smalltalk = json.decode(stStr);
    } catch (e) {
      // Failed to load CKB files
      _personality = {};
      _greetings = {};
      _timeContext = {};
      _identity = {};
      _systemPrompt = {};
      _conversationRules = {};
      _appHelp = {};
      _aiConfig = {};
      _agriculture = {};
      _crops = {};
      _diseases = {};
      _smalltalk = {};
    }
  }

  @override
  Future<ChatMessage> sendMessage({
    required String query,
    required Map<String, dynamic> context,
    required String languageCode,
  }) async {
    await _ensureLoaded();
    final String q = query.toLowerCase().trim();

    final String version = _aiConfig?['config']?['local_kb_version'] ?? '1.0.0';
    final String sys = _systemPrompt?['system_instructions'] ?? '';
    final String style = _personality?['speaking_style'] ?? '';
    final String mapName = _timeContext?['greetings_map']?['morning'] ?? '';
    debugPrint('[OfflineKnowledgeEngine] Running CKB version $version with instructions length: ${sys.length}, speaking style: $style, morning map: $mapName.');

    final String cropName = context['cropName'] ?? '';
    final String diagnosis = context['diagnosis'] ?? '';
    final String timeGreeting = context['timeGreeting'] ?? 'Good Evening';

    // 1. GREETINGS MATCHING (from greetings.json & time_context.json)
    final greetingIntents = _greetings?['greeting_intents'] as List<dynamic>?;
    if (greetingIntents != null) {
      for (final intent in greetingIntents) {
        final List<dynamic>? keywords = intent['keywords'];
        if (keywords != null) {
          for (final kw in keywords) {
            final kwStr = kw.toString().toLowerCase();
            if (q == kwStr || q.startsWith('$kwStr ') || q.startsWith('$kwStr?') || q.startsWith('$kwStr ?') || q.endsWith(' $kwStr') || q.contains(' $kwStr ')) {
              if (kwStr == 'how are you' || q.contains('how are you') || q.contains('how r u')) {
                return ChatMessage(
                  text: 'I am doing great, thank you for asking! I am ready to help you with your crops. How are your fields doing today?',
                  isUser: false,
                  timestamp: DateTime.now(),
                );
              }
              final List<dynamic>? responses = intent['responses'];
              if (responses != null && responses.isNotEmpty) {
                String reply = responses[DateTime.now().millisecond % responses.length];
                if (cropName.isNotEmpty && diagnosis.isNotEmpty) {
                  reply = '$timeGreeting! I noticed you recently scanned a $cropName leaf showing $diagnosis. Would you like me to explain the diagnosis or suggest a treatment plan?';
                }
                return ChatMessage(text: reply, isUser: false, timestamp: DateTime.now());
              }
            }
          }
        }
      }
    }

    // 2. IDENTITY MATCHING (from identity.json)
    final identityQuestions = _identity?['questions'] as List<dynamic>?;
    if (identityQuestions != null) {
      for (final qObj in identityQuestions) {
        final List<dynamic>? keywords = qObj['keywords'];
        if (keywords != null) {
          for (final kw in keywords) {
            if (q.contains(kw.toString().toLowerCase())) {
              return ChatMessage(
                text: qObj['response'],
                isUser: false,
                timestamp: DateTime.now(),
              );
            }
          }
        }
      }
    }

    // 3. APP HELP MATCHING (from app_help.json)
    final helpGuides = _appHelp?['guides'] as List<dynamic>?;
    if (helpGuides != null) {
      for (final guide in helpGuides) {
        final List<dynamic>? keywords = guide['keywords'];
        if (keywords != null) {
          for (final kw in keywords) {
            if (q.contains(kw.toString().toLowerCase())) {
              return ChatMessage(
                text: guide['response'],
                isUser: false,
                timestamp: DateTime.now(),
              );
            }
          }
        }
      }
    }

    // 4. WEATHER CONTEXT (Priority 5)
    final bool isWeatherQuery = q.contains('weather') || q.contains('rain') || 
                                q.contains('humidity') || q.contains('temp') ||
                                q.contains('forecast') || q.contains('precipitation');

    if (isWeatherQuery) {
      final double? temp = context['weatherTemp'];
      final int? humidity = context['weatherHumidity'];
      final double? rain = context['weatherPrecipitation'];
      
      if (temp != null || humidity != null) {
        String weatherReply = 'Current Weather Report:\n';
        if (temp != null) weatherReply += '• Temperature: ${temp.toStringAsFixed(1)}°C\n';
        if (humidity != null) weatherReply += '• Humidity: $humidity%\n';
        if (rain != null) weatherReply += '• Precipitation: ${rain.toStringAsFixed(1)} mm\n';

        if (humidity != null && humidity > 80 && diagnosis.isNotEmpty) {
          weatherReply += '\nAgronomic Alert: The current humidity is high ($humidity%). This creates an ideal environment for foliar pathogens (like $diagnosis) to reproduce and spread. Ensure good crop aeration and avoid overhead watering.';
        } else {
          weatherReply += '\nOptimal conditions for plant transpiration. Keep soil moisture at regular capacity.';
        }
        return ChatMessage(text: weatherReply, isUser: false, timestamp: DateTime.now());
      } else {
        return ChatMessage(
          text: 'Weather data is currently unavailable. Please check your GPS location settings and network connections.',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }
    }

    // 5. SMALLTALK MATCHING (from smalltalk.json - Priority 6)
    final smalltalkIntents = _smalltalk?['intents'] as List<dynamic>?;
    if (smalltalkIntents != null) {
      for (final intent in smalltalkIntents) {
        final List<dynamic>? keywords = intent['keywords'];
        if (keywords != null) {
          for (final kw in keywords) {
            final kwStr = kw.toString().toLowerCase();
            if (q == kwStr || q.contains(kwStr)) {
              final List<dynamic>? responses = intent['responses'];
              if (responses != null && responses.isNotEmpty) {
                final String reply = responses[DateTime.now().millisecond % responses.length];
                return ChatMessage(text: reply, isUser: false, timestamp: DateTime.now());
              }
            }
          }
        }
      }
    }

    // 6. OFFLINE AGRICULTURE/CROP/DISEASE KNOWLEDGE LOOKUPS (Priority 3)
    final cropsList = _crops?['crops_list'] as List<dynamic>?;
    if (cropsList != null) {
      for (final crop in cropsList) {
        final String name = crop['name'] ?? '';
        if (q == name.toLowerCase() || q == 'tell me about ${name.toLowerCase()}') {
          final String type = crop['type'] ?? '';
          final String bestPh = crop['best_ph'] ?? '';
          final String irrigation = crop['irrigation'] ?? '';
          return ChatMessage(
            text: 'Crop Profile: $name\n'
                '• Family Type: $type\n'
                '• Optimal Soil pH: $bestPh\n'
                '• Irrigation Advice: $irrigation',
            isUser: false,
            timestamp: DateTime.now(),
          );
        }
      }
    }

    final tomatoDiseases = _diseases?['tomato_diseases'] as Map<String, dynamic>?;
    if (tomatoDiseases != null) {
      for (final entry in tomatoDiseases.entries) {
        final keyName = entry.key.replaceAll('_', ' ');
        if (q == keyName || q == 'what is $keyName') {
          return ChatMessage(
            text: 'Disease Info: ${keyName.toUpperCase()}\n\n${entry.value}',
            isUser: false,
            timestamp: DateTime.now(),
          );
        }
      }
    }
    final appleDiseases = _diseases?['apple_diseases'] as Map<String, dynamic>?;
    if (appleDiseases != null) {
      for (final entry in appleDiseases.entries) {
        final keyName = entry.key.replaceAll('_', ' ');
        if (q == keyName || q == 'what is $keyName') {
          return ChatMessage(
            text: 'Disease Info: ${keyName.toUpperCase()}\n\n${entry.value}',
            isUser: false,
            timestamp: DateTime.now(),
          );
        }
      }
    }

    if (q.contains('soil') || q.contains('moisture') || q.contains('fertilizer') || q.contains('prune')) {
      final genFarm = _agriculture?['general_farming'] as Map<String, dynamic>?;
      if (genFarm != null) {
        if (q.contains('moisture') || q.contains('soil')) {
          return ChatMessage(text: 'Soil Advice: ${genFarm['soil_moisture']}', isUser: false, timestamp: DateTime.now());
        }
        if (q.contains('fertilizer')) {
          return ChatMessage(text: 'Fertilizer Advice: ${genFarm['fertilizer_timing']}', isUser: false, timestamp: DateTime.now());
        }
        if (q.contains('prune') || q.contains('pruning')) {
          return ChatMessage(text: 'Pruning Advice: ${genFarm['pruning']}', isUser: false, timestamp: DateTime.now());
        }
      }
    }

    // 7. CROP / DISEASE SPECIFIC TREATMENTS (Priority 1, 2, 3)
    if (cropName.isNotEmpty && diagnosis.isNotEmpty) {
      TreatmentProtocol protocol = const TreatmentProtocol(
        directTreatment: 'Inspect crop nodes. Clear dry leaves and ensure organic inputs.',
        preventiveMeasures: 'Clean farming tools and rotate crops to avoid spore carryover.',
        fertilizersPesticides: 'Apply organic compost or local advisory chemical treatments.',
      );

      for (final entry in treatmentMap.entries) {
        if (diagnosis.toLowerCase().contains(entry.key) || entry.key.contains(diagnosis.toLowerCase())) {
          protocol = entry.value;
          break;
        }
      }

      final localizedCrop = TranslationService.translateCrop(cropName, languageCode);
      final localizedDisease = TranslationService.translateDisease(diagnosis, languageCode);
      final p = TranslationService.translateTreatment(diagnosis, languageCode, protocol);

      final asksOrganic = q.contains('organic') || q.contains('organic treatment') || 
                           q.contains('organic solution') || q.contains('organic care') ||
                           q.contains('जैविक') || q.contains('సేంద్రీయ') || q.contains('இயற்கை');

      final asksChemical = q.contains('chemical') || q.contains('medicine') || 
                           q.contains('chemical spray') || q.contains('chemical treatment') ||
                           q.contains('chemical solution') || q.contains('pesticide') ||
                           q.contains('fungicide') || q.contains('रासायनिक') || 
                           q.contains('రసాయన') || q.contains('ரசாயனம்');

      final asksTimeline = q.contains('timeline') || q.contains('recovery') || 
                           q.contains('recovery timeline') || q.contains('how long') ||
                           q.contains('days');

      final asksSpread = q.contains('spread') || q.contains('can it spread') || q.contains('contagious');

      if (asksOrganic) {
        return ChatMessage(
          text: 'For $localizedCrop presenting symptoms of $localizedDisease, here is the organic treatment plan:\n\nOrganic Solution:\n${p.directTreatment}',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }

      if (asksChemical) {
        return ChatMessage(
          text: 'For $localizedCrop presenting symptoms of $localizedDisease, here is the chemical spray protocol:\n\nChemical Treatment:\n${p.fertilizersPesticides}\n\nSafety Precautions: Wear masks during chemical application and wait 48 hours before harvesting.',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }

      if (asksTimeline) {
        return ChatMessage(
          text: 'Recovery Timeline for $localizedCrop ($localizedDisease):\n\nUsually takes 10 to 14 days under consistent treatment. Pruning infected leaves early accelerates recovery.',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }

      if (asksSpread) {
        return ChatMessage(
          text: 'Spread Risk:\n\nYes, foliar pathogens can spread rapidly to nearby healthy crops via wind splashes or infected tools. Isolate the affected crop and sanitize pruning shears immediately.',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }

      // Default comprehensive structured response
      final double confidence = context['confidence'] ?? 0.85;
      final String severity = context['severity'] ?? 'Moderate';
      
      return ChatMessage(
        text: 'Kavya Diagnostic Summary:\n'
            '• Crop: $localizedCrop\n'
            '• Diagnosis: $localizedDisease\n'
            '• Severity: $severity\n'
            '• AI Confidence: ${(confidence * 100).toStringAsFixed(1)}%\n\n'
            'Organic Treatment:\n${p.directTreatment}\n\n'
            'Chemical Spray:\n${p.fertilizersPesticides}\n\n'
            'Preventive Measures:\n${p.preventiveMeasures}\n\n'
            'Recovery Timeline: 10–14 days.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }

    final List<dynamic>? fallbacks = _conversationRules?['unknown_fallback']?['responses'];
    final String fallbackText = (fallbacks != null && fallbacks.isNotEmpty)
        ? fallbacks[DateTime.now().millisecond % fallbacks.length].toString()
        : 'I am Kavya. I specialize in offline crop diagnostics, weather analysis, and agronomic care. Please try scanning a leaf in the "Scan" tab or ask me a weather query!';

    return ChatMessage(
      text: fallbackText,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}

class FastAPIEngine implements AIEngine {
  final String resolvedBaseUrl;

  FastAPIEngine({required this.resolvedBaseUrl});

  @override
  Future<ChatMessage> sendMessage({
    required String query,
    required Map<String, dynamic> context,
    required String languageCode,
  }) async {
    final cropName = context['cropName'] ?? 'General';
    final diagnosis = context['diagnosis'] ?? 'General';

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
      // Fallback handled by the coordinator service
    }

    // Dynamic fallback to local knowledge engine
    return OfflineKnowledgeEngine().sendMessage(
      query: query,
      context: context,
      languageCode: languageCode,
    );
  }
}

class GeminiEngine implements AIEngine {
  @override
  Future<ChatMessage> sendMessage({
    required String query,
    required Map<String, dynamic> context,
    required String languageCode,
  }) async {
    // Stub for cloud direct LLM integration
    return ChatMessage(
      text: '[Gemini Cloud AI] Offline fallback triggered. Direct Gemini API queries are stubbed for Phase C.',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
