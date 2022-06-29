import 'package:eventora/services/api_services.dart';

class FeaturePageController {
  Future getFeed() async {
    Map<String, dynamic> response =
        await ApiService().request('feature_page/feed', 'GET', {}, true);

    return response;
  }

  Future getFeatures() async {
    Map<String, dynamic> response =
        await ApiService().request('feature_page', 'GET', {}, true);

    return response;
  }
}
