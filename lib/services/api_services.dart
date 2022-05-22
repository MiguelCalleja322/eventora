import 'package:eventora/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  Future<dynamic> request(
    String url,
    String? type,
    Map<String, String?> data,
    bool? withToken,
  ) async {
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['APP_URL'];
    final String? storageKey = dotenv.env['STORAGE_KEY'];

    final Uri completeUri = Uri.parse('$baseUrl/$url');

    String? token;
    dynamic body;

    final http.Request request = http.Request(type!, completeUri);
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // if (withToken == true) {
    //   token = await SecureStorage.readValue(key: SecureStorage.userTokenKey);
    //   headers['Authorization'] = 'Bearer $token';
    //   print(token);
    //
    request.headers.addAll(headers);

    request.body = jsonEncode(data);

    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response =
        await http.Response.fromStream(streamedResponse);

    if (response.body.isNotEmpty) {
      body = jsonDecode(response.body);
    }

    if (body['access_token']) {
      StorageSevice().write(storageKey!, body['access_token']);
    }

    print(body);

    return body;
  }
}
