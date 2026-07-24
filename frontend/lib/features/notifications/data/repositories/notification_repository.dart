import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  static const String boxName = 'app_notifications';

  Box get _box => Hive.box(boxName);

  List<AppNotification> getNotifications() {
    final list = _box.values.map((v) {
      final map = Map<String, dynamic>.from(v as Map);
      return AppNotification.fromJson(map);
    }).toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> addNotification(AppNotification notification) async {
    await _box.put(notification.id, notification.toJson());
  }

  Future<void> markAsRead(String id) async {
    final val = _box.get(id);
    if (val != null) {
      final map = Map<String, dynamic>.from(val as Map);
      map['isRead'] = true;
      await _box.put(id, map);
    }
  }

  Future<void> markAllAsRead() async {
    for (final key in _box.keys) {
      final val = _box.get(key);
      if (val != null) {
        final map = Map<String, dynamic>.from(val as Map);
        map['isRead'] = true;
        await _box.put(key, map);
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) => NotificationRepository());

final notificationsListProvider = StateNotifierProvider<NotificationsListNotifier, List<AppNotification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final notifier = NotificationsListNotifier(repo);
  notifier.seedInitialNotificationsIfEmpty();
  return notifier;
});

class NotificationsListNotifier extends StateNotifier<List<AppNotification>> {
  final NotificationRepository _repo;

  NotificationsListNotifier(this._repo) : super([]) {
    refresh();
  }

  void refresh() {
    state = _repo.getNotifications();
  }

  void seedInitialNotificationsIfEmpty() {
    final current = _repo.getNotifications();
    if (current.isEmpty) {
      _repo.addNotification(AppNotification(
        id: 'seed-1',
        title: 'Welcome to KrishiOS!',
        body: 'Start scanning your crop leaves for real-time offline AI diagnosis.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.system,
      ));
      _repo.addNotification(AppNotification(
        id: 'seed-2',
        title: 'Version 1.0.0 Released',
        body: 'Check out the new offline agronomy database and interactive expert advisors.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.appUpdate,
      ));
      _repo.addNotification(AppNotification(
        id: 'seed-3',
        title: 'Weather Forecast Alert',
        body: 'Bachamari area forecast predicts heavy rains tomorrow. Plan irrigation accordingly.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.announcement,
      ));
      refresh();
    }
  }

  Future<void> add(AppNotification notification) async {
    await _repo.addNotification(notification);
    refresh();
  }

  Future<void> markRead(String id) async {
    await _repo.markAsRead(id);
    refresh();
  }

  Future<void> markAllRead() async {
    await _repo.markAllAsRead();
    refresh();
  }

  Future<void> delete(String id) async {
    await _repo.deleteNotification(id);
    refresh();
  }

  Future<void> clear() async {
    await _repo.clearAll();
    refresh();
  }
}
