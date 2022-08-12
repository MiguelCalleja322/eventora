import 'package:eventora/models/user.dart';

class Notifications {
  final List<dynamic>? notifications;

  Notifications({this.notifications});

  factory Notifications.fromJson(List<dynamic> json) {
    return Notifications(
        notifications: json
            .map((notification) => Notification.fromJson(notification))
            .toList());
  }
}

class Notification {
  String? eventSlug;
  String? label;
  String? createdAt;
  int? isRead;
  int? id;
  User? user;

  Notification({
    this.eventSlug,
    this.label,
    this.isRead,
    this.user,
    this.createdAt,
    this.id,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      eventSlug: json['event_slug'],
      createdAt: json['created_at'],
      label: json['label'],
      id: json['id'],
      isRead: json['is_read'],
      user: User.fromJson(json['user']),
    );
  }
}
