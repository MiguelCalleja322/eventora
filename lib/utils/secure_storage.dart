import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageSevice {
  final secureStorage = const FlutterSecureStorage();

  static String roleKey = 'ROLE_KEY';
  static String storageKey = 'STORAGE_KEY';
  static String userInfoKey = 'USERINFO_KEY';
  Future<void> write(String key, String value) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      key,
    );
  }

  Future<void> delete(String key) async {
    secureStorage.delete(key: key);
  }
}
