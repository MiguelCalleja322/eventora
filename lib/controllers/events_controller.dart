import 'package:eventora/services/api_services.dart';

class EventController {
  Future store(Map<String, dynamic> eventData) async {
    Map<String, dynamic> response =
        await ApiService().request('organizer/events', 'POST', eventData, true);

    return response;
  }

  Future saveEvent(Map<String, dynamic> slug) async {
    Map<String, dynamic> response =
        await ApiService().request('saveEvent', 'GET', slug, true);

    return response;
  }

  Future show(String slug) async {
    Map<String, dynamic> response =
        await ApiService().request('events/$slug', 'GET', {}, true);

    return response;
  }

  Future shareEvent(Map<String, dynamic> slug) async {
    Map<String, dynamic> response =
        await ApiService().request('shareEvent', 'POST', slug, true);

    return response;
  }

  Future interested(Map<String, dynamic> slug) async {
    Map<String, dynamic> response =
        await ApiService().request('userInterested', 'POST', slug, true);

    return response;
  }

  Future like(Map<String, dynamic> slug) async {
    return await ApiService().request('events/eventLike', 'POST', slug, true);
  }
}
