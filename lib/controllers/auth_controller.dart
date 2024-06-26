import 'dart:convert';

import 'package:eventora/services/api_services.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/notifier.dart';

class AuthController {
  final notifier = Notifier();
  late String newToken;

  Future<int> authUser() async {
    final Map<String, dynamic> response =
        await ApiService().request('auth_user', 'GET', {}, true);

    if (response.containsKey('message')) {
      return 401;
    }
    await notifier.initializeNotifications();
    // await StorageSevice()
    //     .write(StorageSevice.storageKey, response['access_token']);

    await StorageSevice()
        .write(StorageSevice.userInfoKey, jsonEncode(response));
    initFCM();
    return 200;
  }

  Future login(Map<String, String?> loginData) async {
    Map<String, dynamic> response =
        await ApiService().request('login', 'POST', loginData, false);

    if (response['access_token'] != null && response['role'] != null) {
      await notifier.initializeNotifications();
      await StorageSevice()
          .write(StorageSevice.storageKey, response['access_token']);
      await StorageSevice()
          .write(StorageSevice.userInfoKey, jsonEncode(response));
      initFCM();
    }
    return response;
  }

  Future signup(Map<String, String?> signupData) async {
    Map<String, dynamic> response =
        await ApiService().request('signup', 'POST', signupData, false);

    if (response['access_token'] != null && response['role'] != null) {
      await notifier.initializeNotifications();
      await StorageSevice()
          .write(StorageSevice.storageKey, response['access_token']);
      await StorageSevice()
          .write(StorageSevice.userInfoKey, jsonEncode(response));
      initFCM();
    }
    return response;
  }

  Future verifyAccount(Map<String, String?> otp) async {
    Map<String, dynamic> response =
        await ApiService().request('user/verify', 'PUT', otp, true);
    return response;
  }

  Future requestNewOTP() async {
    await ApiService().request('user/requestNewOTP', 'POST', {}, true);
  }

  Future getProfile() async {
    Map<String, dynamic> response =
        await ApiService().request('user/getProfile', 'GET', {}, true);

    return response;
  }

  Future userUpdate(Map<String, dynamic> userInfo) async {
    Map<String, dynamic> response =
        await ApiService().request('user/update', 'PUT', userInfo, true);

    return response;
  }

  Future logout() async {
    await dotenv.load(fileName: ".env");

    final String? storageKey = dotenv.env['STORAGE_KEY'];
    final String? roleKey = dotenv.env['ROLE_KEY'];
    await ApiService().request('user/logout', 'POST', {}, true);
    await StorageSevice().delete(roleKey!);
    await StorageSevice().delete(storageKey!);
  }

  void setToken(String? token) {
    if (token != null) {
      newToken = token;
      ApiService()
          .request('auth/fcm_token', 'PUT', {'firebase_token': token}, false);
    }
  }

  void initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    messaging.onTokenRefresh.listen(setToken);

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      // goToContentFromNotification(initialMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        notifier.notify(message.notification!.title!,
            message.notification!.body!, message.data);
      }
    });
  }
  // Future<bool> checkServer(String? apiUrl) async {
  //   Uri uri = Uri.parse('${apiUrl}ping');
  //   try {
  //     http.Response response = await http.get(uri);
  //     // ignore: unnecessary_null_comparison
  //     return response != null;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
