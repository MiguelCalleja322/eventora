import 'package:eventora/models/statistics.dart';
import 'package:eventora/services/api_services.dart';

class StatisticsController {
  static Future<Statistics?> getStatistics() async {
    Statistics? statistics;
    Map<String, dynamic> response =
        await ApiService().request('organizer/statistics', 'GET', {}, true);

    if (response['statistics'] is List<dynamic>) {
      statistics = Statistics.fromJson(response['statistics']);
    }
    return statistics;
  }
}
