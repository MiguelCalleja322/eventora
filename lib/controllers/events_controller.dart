import 'package:eventora/services/api_services.dart';

class EventController {
  Future store(Map<String, dynamic> eventData) async {
    Map<String, dynamic> response =
        await ApiService().request('organizer/events', 'POST', eventData, true);

    return response;
  }
}
