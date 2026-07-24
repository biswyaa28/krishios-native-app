import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class LocalNotificationService {
  final Ref _ref;

  LocalNotificationService(this._ref);

  Future<void> triggerNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? route,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final notification = AppNotification(
      id: id,
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: type,
      route: route,
    );
    
    await _ref.read(notificationsListProvider.notifier).add(notification);
  }
}

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService(ref);
});
