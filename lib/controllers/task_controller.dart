import 'package:eventora/services/api_services.dart';

class TaskController {
  static Future store(Map<String, dynamic> taskData) async {
    Map<String, dynamic> response =
        await ApiService().request('tasks', 'POST', taskData, true);
    return response;
  }

  static Future delete(int id) async {
    Map<String, dynamic> response =
        await ApiService().request('tasks/$id', 'DELETE', {}, true);
    return response;
  }

  static Future update(Map<String, dynamic> taskData) async {
    Map<String, dynamic> response =
        await ApiService().request('tasks', 'PUT', taskData, true);
    return response;
  }
}
