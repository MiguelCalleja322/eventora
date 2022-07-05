import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationController {
  Future<Map<String, dynamic>> getPlace(String placeId) async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    final String? googleApisUrl = dotenv.env['GOOGLE_API_URL'];

    final String url = '$googleApisUrl/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = convert.jsonDecode(response.body);
    Map<String, dynamic> results = json['result'];

    return results;
  }

  Future<Map<String, dynamic>> getPlaceUsingCoordinates(LatLng input) async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    final String? googleApisUrl = dotenv.env['GOOGLE_API_URL'];
    late double latitude = 0.0;
    late double longitude = 0.0;

    latitude = input.latitude;
    longitude = input.longitude;

    // final String placeId = await getPlaceId();

    final String url =
        '$googleApisUrl/autocomplete/xml?types=establishment&location=$latitude,$longitude&radius=500&strictbounds&key=$key';

    print(url);

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = convert.jsonDecode(response.body);
    Map<String, dynamic> results = json['result'];

    print(results);

    return {};
  }
}
