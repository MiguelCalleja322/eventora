import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationController {
  Future<String> getPlaceId(String input) async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    final String? googleApisUrl = dotenv.env['GOOGLE_API_URL'];

    final String url =
        '$googleApisUrl/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = convert.jsonDecode(response.body);
    String placeId = json['candidates'][0]['place_id'].toString();

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    final String? googleApisUrl = dotenv.env['GOOGLE_API_URL'];

    final String placeId = await getPlaceId(input);

    final String url = '$googleApisUrl/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = convert.jsonDecode(response.body);
    Map<String, dynamic> results = json['result'];

    return results;
  }
}
