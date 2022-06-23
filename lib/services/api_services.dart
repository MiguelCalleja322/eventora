import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  Future<dynamic> request(
    String url,
    String? type,
    Map<String, dynamic> data,
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

    if (withToken == true) {
      token = await StorageSevice().read(storageKey!);
      headers['Authorization'] = 'Bearer $token';
    }

    request.headers.addAll(headers);

    request.body = jsonEncode(data);

    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response =
        await http.Response.fromStream(streamedResponse);

    if (response.body.isNotEmpty) {
      body = jsonDecode(response.body);
    }

    // if (response.statusCode != 200 || response.statusCode != 201) {
    //   Fluttertoast.showToast(
    //       msg: response['message'].toString(),
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.grey[500],
    //       textColor: Colors.white,
    //       timeInSecForIosWeb: 3,
    //       toastLength: Toast.LENGTH_LONG,
    //       fontSize: 16.0);
    //   return;
    // }

    // if (body['access_token'] != null) {
    //   await StorageSevice().write(storageKey!, body['access_token']);
    // }

    // print(body);

    // token = await StorageSevice().read(storageKey!);
    // print('access');
    // print(token);

    return body;
  }
}
