import 'package:eventora/services/api_services.dart';

class UserEventController {
  static Future store(Map<String, dynamic> eventData) async {
    Map<String, dynamic> response =
        await ApiService().request('user_event', 'POST', eventData, true);

    return response;
  }

  static Future show(String? slug) async {
    Map<String, dynamic> response =
        await ApiService().request('user_event/$slug', 'POST', {}, true);

    return response;
  }
}
