import 'package:eventora/services/api_services.dart';

class TaskController {
  Future store(Map<String, dynamic> taskData) async {
    Map<String, dynamic> response =
        await ApiService().request('tasks', 'POST', taskData, true);
    return response;
  }
}
