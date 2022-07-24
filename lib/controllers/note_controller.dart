import 'package:eventora/models/notes.dart';
import 'package:eventora/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteController {
  Future store(Map<String, dynamic> noteData) async {
    Map<String, dynamic> response =
        await ApiService().request('notes', 'POST', noteData, true);

    return response;
  }

  static Future<Notes?> index() async {
    Notes? notes;
    Map<String, dynamic> response =
        await ApiService().request('notes', 'GET', {}, true);
    if (response['notes'] is List<dynamic>) {
      notes = Notes.fromJson(response['notes']);
    }

    return notes;
  }

  Future delete(int? id) async {
    Map<String, dynamic> response =
        await ApiService().request('notes/$id', 'DELETE', {}, true);
    return response;
  }
}
