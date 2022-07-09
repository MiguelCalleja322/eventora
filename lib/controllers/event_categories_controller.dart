import 'package:eventora/services/api_services.dart';

class EventCategoriesController {
  Future index() async {
    Map<String, dynamic> response =
        await ApiService().request('eventCategories', 'GET', {}, true);

    return response;
  }
}
