import 'package:eventora/models/user.dart';

class Notifications {
  final List<Notification>? notifications;

  Notifications({this.notifications});

  factory Notifications.fromJson(List<dynamic> json) {
    return Notifications(
        notifications: json
            .map((notification) => Notification.fromJson(notification))
            .toList());
  }
}

class Notification {
  String eventSlug;
  String label;
  int isRead;
  List<User> user;

  Notification({
    required this.eventSlug,
    required this.label,
    required this.isRead,
    required this.user,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      eventSlug: json['event_slug'],
      label: json['label'],
      isRead: json['isRead'],
      user: json['user'],
    );
  }
}
