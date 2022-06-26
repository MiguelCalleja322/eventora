import 'package:eventora/services/api_services.dart';

class CalendarController {
  Future index() async {
    Map<String, dynamic> response =
        await ApiService().request('calendar', 'GET', {}, true);
    return response;
  }
}
