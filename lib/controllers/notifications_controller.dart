import 'package:eventora/models/notification.dart';
import 'package:eventora/services/api_services.dart';

class NotificationsController {
  static Future<Notifications?> index() async {
    Notifications? notifications;
    Map<String, dynamic> response =
        await ApiService().request('notifications', 'GET', {}, true);

    if (response['notifications'] is List<dynamic>) {
      notifications = Notifications.fromJson(response['notifications']);
    }

    return notifications;
  }

  static Future read(int id) async {
    await ApiService().request('notifications/read/$id', 'PUT', {}, true);
  }
}
