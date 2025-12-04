import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}

class NotificationProvider with ChangeNotifier {
  final Uuid _uuid = Uuid();
  final List<NotificationModel> _notifications = [
    NotificationModel(
        id: Uuid().v4(),
        title: 'Promo Spesial 12.12',
        message: 'Dapatkan diskon 50% untuk semua menu coffee hari ini!',
        date: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationModel(
        id: Uuid().v4(),
        title: 'Kopi Baru: Vanilla Mint',
        message: 'Coba menu seasonal terbaru kami. Tersedia terbatas!',
        date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  List<NotificationModel> get notifications => _notifications.reversed.toList();

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String notificationId) {
    final notification = _notifications.firstWhere((n) => n.id == notificationId, orElse: () => throw Exception('Notif not found'));
    if (!notification.isRead) {
      notification.isRead = true;
      notifyListeners();
    }
  }

  void markAsReadByIndex(int index) {
    if (index < 0 || index >= _notifications.length) return;
    _notifications[index].isRead = true;
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void addNotification(String title, String message) {
    _notifications.add(NotificationModel(
      id: _uuid.v4(),
      title: title,
      message: message,
      date: DateTime.now(),
    ));
    notifyListeners();
  }
}