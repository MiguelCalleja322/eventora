import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSevice {
  final secureStorage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    Future<String?> token = secureStorage.read(key: key);
    return token;
  }

  Future<void> delete(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }
}
