import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSevice {
  final secureStorage = const FlutterSecureStorage();
  String? token;
  Future<void> write(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    token = await secureStorage.read(key: key);
    return token;
  }

  Future<void> delete(String key) async {
    secureStorage.delete(key: key);
  }
}
