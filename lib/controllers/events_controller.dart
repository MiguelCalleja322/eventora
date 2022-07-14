import 'package:eventora/services/api_services.dart';

class EventController {
  Future store(Map<String, dynamic> eventData) async {
    Map<String, dynamic> response =
        await ApiService().request('events', 'POST', eventData, true);

    return response;
  }

  Future saveEvent(Map<String, dynamic> slug) async {
    Map<String, dynamic> response =
        await ApiService().request('saveEvent', 'POST', slug, true);

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

  Future update(Map<String, dynamic> dataToUpdate) async {
    return await ApiService().request('events', 'PUT', dataToUpdate, true);
  }

  Future like(Map<String, dynamic> slug) async {
    return await ApiService().request('events/eventLike', 'POST', slug, true);
  }

  Future delete(String slug) async {
    return await ApiService().request('events/$slug', 'DELETE', {}, true);
  }

  Future markAsPrivate(String slug) async {
    return await ApiService()
        .request('events/mark_as_private/$slug', 'PUT', {}, true);
  }

  Future availability(String slug) async {
    return await ApiService()
        .request('events/availability/$slug', 'PUT', {}, true);
  }
}
