import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSevice {
  final secureStorage = const FlutterSecureStorage();
  late String token;

  Future<void> write(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    token = secureStorage.read(key: key) as String;
    return token;
  }

  Future<void> delete(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }
}
