import 'dart:convert';
import 'package:eventora/services/api_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

class Notifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // ignore: prefer_typing_uninitialized_variables
  var platformChannelSpecifics;

  Future<void> initializeNotifications() async {
    await Permission.notification.request();
    var iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(sound: 'notif_sound.caf');
    var androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('1', 'eventora',
            // sound: RawResourceAndroidNotificationSound('notifsound'),
            importance: Importance.max,
            priority: Priority.high);
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android: androidPlatformChannelSpecifics);
    var initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    if (payload != null) {
      Map<String, dynamic> notification = jsonDecode(payload);
      switch (notification['type']) {
        case 'post':
          Map<String, dynamic>? response = await ApiService().request(
            'posts/${notification['data']['post']['slug']}',
            'GET',
            {},
            true,
          );

          break;

        case 'conversation':
        // Get.find<NavController>()
        //     .openConversation(notification['message'], navigator?.context);
        // break;
      }
    }
  }

  notify(String title, String body, Map<String, dynamic> data) async {
    await flutterLocalNotificationsPlugin.show(
        1, title, body, platformChannelSpecifics,
        payload: jsonEncode(data));
  }
}
