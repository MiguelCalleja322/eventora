import 'package:eventora/models/notification.dart';
import 'package:eventora/services/api_services.dart';

class NotificationsController {
  static Future index() async {
    Notifications? notifications;
    Map<String, dynamic> response =
        await ApiService().request('notifications', 'GET', {}, true);

    if (response['notifications'] is List<dynamic>) {
      notifications = Notifications.fromJson(response['notifications']);
    }

    return notifications;
  }
}
