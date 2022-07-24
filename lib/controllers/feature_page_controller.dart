import 'dart:convert';

import 'package:eventora/models/features.dart';
import 'package:eventora/services/api_services.dart';

class FeaturePageController {
  Future getFeed() async {
    Map<String, dynamic> response =
        await ApiService().request('feature_page/feed', 'GET', {}, true);

    return response;
  }

  static Future<Features?> index() async {
    Features? features;
    Map<String, dynamic> response =
        await ApiService().request('feature_page', 'GET', {}, true);
    if (response['featured'] is List<dynamic>) {
      features = Features.fromJson(response['featured']);
    }

    return features;
  }
}
