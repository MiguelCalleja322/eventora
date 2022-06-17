import 'package:eventora/services/api_services.dart';

class StatisticsController {
  Future getStatistics() async {
    Map<String, dynamic> response =
        await ApiService().request('organizer/statistics', 'GET', {}, true);
    return response;
  }
}
