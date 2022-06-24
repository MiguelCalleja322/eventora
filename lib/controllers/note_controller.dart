import 'package:eventora/services/api_services.dart';

class NoteController {
  Future store(Map<String, dynamic> noteData) async {
    Map<String, dynamic> response =
        await ApiService().request('notes', 'POST', noteData, true);
    return response;
  }
}
