import 'package:eventora/services/api_services.dart';

class UserPreferenceController {
  static Future store(String eventCategory) async {
    await ApiService()
        .request('user_preference/$eventCategory', 'POST', {}, true);
  }
}
