import 'package:eventora/services/api_services.dart';

class FeaturePageController {
  Future getFeatures() async {
    Map<String, dynamic> response =
        await ApiService().request('feature_page', 'GET', {}, true);

    return response;
  }
}
