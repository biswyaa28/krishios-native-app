import '../../../../features/scan/domain/models/chat_message.dart';

List<ChatMessage> mockMessagesWheat = [
  ChatMessage(
    text:
        'Scan analysis complete for Wheat A-12. No signs of disease detected. Crop appears healthy with strong color and uniform growth.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ChatMessage(
    text: 'Great! Should I continue with the current irrigation schedule?',
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
  ),
  ChatMessage(
    text:
        'Yes, your current schedule is optimal. Maintain soil moisture at 60-70%. Next recommended scan in 7 days to monitor early-stage indicators.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
  ),
];

List<ChatMessage> mockMessagesCorn = [
  ChatMessage(
    text:
        '⚠️ Aphid infestation detected in Corn B-04. Estimated 15-20% of leaf surface affected across the southwest section. Immediate action recommended.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 26)),
  ),
  ChatMessage(
    text: 'What treatment do you suggest?',
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(hours: 25, minutes: 45)),
  ),
  ChatMessage(
    text:
        'Apply Neem oil-based pesticide (2ml/L) in the evening when temperatures are below 30°C. Focus on the underside of leaves. Re-scan in 48 hours to monitor effectiveness.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 25, minutes: 40)),
  ),
  ChatMessage(
    text: 'Should I inform neighboring fields?',
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(hours: 25, minutes: 30)),
  ),
  ChatMessage(
    text:
        'Yes, aphids spread quickly. Notify farmers within a 500m radius to check their crops preventively.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 25, minutes: 25)),
  ),
];

List<ChatMessage> mockMessagesSoy = [
  ChatMessage(
    text:
        'Soil moisture analysis for Soy C-01 shows optimal levels at 65%. No irrigation needed for the next 2-3 days given the current forecast.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 50)),
  ),
  ChatMessage(
    text: "How's the overall plant health looking?",
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(hours: 49, minutes: 40)),
  ),
  ChatMessage(
    text:
        'Plant health index is at 85/100. Good nodulation observed across the field. Continue with current fertilizer plan and consider a foliar spray of micronutrients at pod formation stage for optimal yield.',
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(hours: 49, minutes: 35)),
  ),
];
