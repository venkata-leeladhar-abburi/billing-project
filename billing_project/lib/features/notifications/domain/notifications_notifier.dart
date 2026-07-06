import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_notifier.g.dart';

enum NotificationType { creditLow, paymentSuccess, paymentFailed, billDelivered, bulkSent }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationsState {
  const NotificationsState({required this.notifications});

  final List<NotificationItem> notifications;
}

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  AsyncValue<NotificationsState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real notificationsRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    state = AsyncValue.data(
      NotificationsState(
        notifications: [
          NotificationItem(
            id: 'n1',
            type: NotificationType.creditLow,
            title: 'Bill credits running low',
            body: 'Only 18 bill credits left. Buy more.',
            timestamp: now.subtract(const Duration(minutes: 10)),
          ),
          NotificationItem(
            id: 'n2',
            type: NotificationType.billDelivered,
            title: 'Bill delivered',
            body: 'Suresh Kumar received your bill.',
            timestamp: now.subtract(const Duration(hours: 1)),
          ),
          NotificationItem(
            id: 'n3',
            type: NotificationType.paymentSuccess,
            title: 'Payment successful',
            body: '₹599 payment successful. Next billing: 1 Aug 2026.',
            timestamp: now.subtract(const Duration(days: 2)),
            isRead: true,
          ),
          NotificationItem(
            id: 'n4',
            type: NotificationType.bulkSent,
            title: 'Campaign sent',
            body: 'Campaign sent to 128 customers.',
            timestamp: now.subtract(const Duration(days: 3)),
            isRead: true,
          ),
          NotificationItem(
            id: 'n5',
            type: NotificationType.paymentFailed,
            title: 'AutoPay failed',
            body: 'Update your UPI to continue.',
            timestamp: now.subtract(const Duration(days: 10)),
            isRead: true,
          ),
        ],
      ),
    );
  }

  void markAllRead() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      NotificationsState(
        notifications: [
          for (final n in current.notifications) n.copyWith(isRead: true),
        ],
      ),
    );
  }
}
