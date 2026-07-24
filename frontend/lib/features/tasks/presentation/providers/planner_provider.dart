import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/features/scan/presentation/providers/scan_provider.dart';
import 'package:krishios/features/weather/presentation/providers/weather_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/task_model.dart';

class DailyPlan {
  final String title;
  final String subtitle;
  final String bestTimeToIrrigate;
  final String bestTimeToSpray;
  final String bestTimeToHarvest;
  final String weatherAlertText;
  final List<Task> recommendedTasks;

  DailyPlan({
    required this.title,
    required this.subtitle,
    required this.bestTimeToIrrigate,
    required this.bestTimeToSpray,
    required this.bestTimeToHarvest,
    required this.weatherAlertText,
    required this.recommendedTasks,
  });
}

final dailyPlanProvider = Provider<DailyPlan>((ref) {
  final weatherAsync = ref.watch(weatherProvider);
  final scans = ref.watch(scanHistoryProvider);

  final weather = weatherAsync.value;
  final hasScans = scans.isNotEmpty;
  final latestScan = hasScans ? scans.first : null;

  // 1. Personalized Greeting Title & Subtitle based on time and scan history
  final now = DateTime.now();
  final hour = now.hour;
  String greeting = 'Good Morning';
  if (hour >= 12 && hour < 17) {
    greeting = 'Good Afternoon';
  } else if (hour >= 17 || hour < 5) {
    greeting = 'Good Evening';
  }

  final user = FirebaseAuth.instance.currentUser;
  String displayName = 'Farmer';
  if (user != null) {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      displayName = user.displayName!;
    } else if (user.email != null && user.email!.isNotEmpty) {
      final parts = user.email!.split('@');
      if (parts.isNotEmpty) {
        final namePart = parts[0].split(RegExp(r'[\._]'))[0];
        if (namePart.isNotEmpty) {
          displayName = namePart[0].toUpperCase() + namePart.substring(1);
        }
      }
    }
  }

  final title = '$greeting, $displayName';
  String subtitle = 'Hope your crops are doing well today.';
  if (latestScan != null) {
    subtitle = 'Hope your ${latestScan.cropName.toLowerCase()} crop is doing well today.';
  }

  // 2. Weather conditions
  final temp = weather?.temperature ?? 28.0;
  final humidity = weather?.humidity ?? 65;
  final rainProb = (weather?.precipitation ?? 0.0) > 0.0 ? 80 : 10;
  final windSpeed = weather?.windSpeed ?? 12.0;

  // 3. Determine best times based on microclimate rules
  String bestIrrigate = '06:00 AM - 08:00 AM';
  String bestSpray = '04:00 PM - 06:00 PM';
  String bestHarvest = '08:00 AM - 11:00 AM';
  String weatherAlert = 'No critical weather warning. Good conditions overall.';

  if (temp > 35) {
    bestIrrigate = '05:00 AM - 07:00 AM (Early morning to avoid high heat evaporation)';
    bestSpray = '06:00 PM - 08:00 PM (Late evening to prevent crop chemical burns)';
    bestHarvest = '06:00 AM - 09:00 AM (Before intense sunlight)';
    weatherAlert = 'High heat alert! Avoid activities during peak sun hours.';
  } else if (rainProb > 50) {
    bestIrrigate = 'Not recommended (Rain forecast suggests natural watering)';
    bestSpray = 'Avoid spraying (Rainfall will wash away treatments)';
    bestHarvest = 'Delay harvesting (Wet crops are highly prone to fungal rot)';
    weatherAlert = 'Precipitation warning. Delay chemical applications and crop harvesting.';
  } else if (windSpeed > 25) {
    bestSpray = 'Avoid spraying (High winds will cause pesticide drift)';
    weatherAlert = 'Strong winds detected. Avoid spraying and secure loose crop shelters.';
  }

  // 4. Generate recommendation tasks based on current context
  final recommended = <Task>[];
  
  // Rule A: Irrigation recommendation
  if (rainProb < 30 && temp > 30) {
    recommended.add(Task(
      id: 'rec_irrigate',
      title: latestScan != null ? 'Irrigate ${latestScan.cropName} Field' : 'Irrigate Sector A',
      description: 'Soil moisture is dropping due to dry weather. Recommended depth: 1.5 inches.',
      priority: TaskPriority.high,
      estimatedDurationMinutes: 45,
      status: TaskStatus.pending,
      category: TaskCategory.irrigation,
      dueDate: DateTime(now.year, now.month, now.day, 8, 0),
    ));
  }

  // Rule B: Fungal spray recommendation based on scans or high humidity
  if (latestScan != null && (latestScan.diagnosis.toLowerCase().contains('fungal') || latestScan.diagnosis.toLowerCase().contains('spot') || humidity > 80)) {
    recommended.add(Task(
      id: 'rec_fungicide',
      title: 'Spray fungicide in ${latestScan.fieldName}',
      description: 'Recent scans of ${latestScan.cropName} indicate a vulnerability to fungal spread under high humidity.',
      priority: TaskPriority.high,
      estimatedDurationMinutes: 60,
      status: TaskStatus.pending,
      category: TaskCategory.pesticide,
      dueDate: DateTime(now.year, now.month, now.day, 17, 0),
    ));
  }

  // Rule C: Crop inspection
  if (latestScan != null) {
    recommended.add(Task(
      id: 'rec_inspect',
      title: 'Inspect surrounding ${latestScan.cropName} plants',
      description: 'Perform visual inspection of leaves within 10 meters of the last diagnostic scan location.',
      priority: TaskPriority.medium,
      estimatedDurationMinutes: 30,
      status: TaskStatus.pending,
      category: TaskCategory.inspect,
      dueDate: DateTime(now.year, now.month, now.day, 10, 0),
    ));
  }



  return DailyPlan(
    title: title,
    subtitle: subtitle,
    bestTimeToIrrigate: bestIrrigate,
    bestTimeToSpray: bestSpray,
    bestTimeToHarvest: bestHarvest,
    weatherAlertText: weatherAlert,
    recommendedTasks: recommended,
  );
});
