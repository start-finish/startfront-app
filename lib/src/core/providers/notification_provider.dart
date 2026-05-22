import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationType { alert, user, trade, info }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier() : super([]) {
    // Load mock data
    _loadMockData();
  }

  void _loadMockData() {
    state = [
      NotificationItem(
        id: '1',
        title: 'System Alert',
        message: 'Critical Error: Server Overload detected in APAC-1.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        type: NotificationType.alert,
      ),
      NotificationItem(
        id: '2',
        title: 'New User Joined',
        message: 'Alex R. has signed up as a Premium member.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.user,
      ),
      NotificationItem(
        id: '3',
        title: 'Trade Executed',
        message: 'BTC/USDT Buy order filled at \$64,230.50.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        type: NotificationType.trade,
      ),
      NotificationItem(
        id: '4',
        title: 'Security Update',
        message: 'Your password was changed successfully.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.info,
        isRead: true,
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final item in state) item.copyWith(isRead: true),
    ];
  }

  void clearAll() {
    state = [];
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});
