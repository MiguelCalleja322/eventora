import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSevice {
  final secureStorage = const FlutterSecureStorage();
  static String roleKey = 'ROLE_KEY';
  static String storageKey = 'STORAGE_KEY';
  static String userInfoKey = 'USERINFO_KEY';
  Future<void> write(String? key, String? value) async {
    print('write:$key');
    secureStorage.write(key: key!, value: value);
  }

  Future<String?> read(String key) async {
    print('read:$key');
    return await secureStorage.read(
      key: key,
    );
  }

  Future<void> delete(String key) async {
    secureStorage.delete(key: key);
  }
}
