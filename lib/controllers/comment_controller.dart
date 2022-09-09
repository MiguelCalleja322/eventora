import 'package:eventora/models/comment.dart';
import 'package:eventora/services/api_services.dart';

class CommentController {
  static Future store(Map<String, dynamic> commentData) async {
    Map<String, dynamic> response =
        await ApiService().request('comments', 'POST', commentData, true);
    return response;
  }

  static Future<Comments?> index(String slug) async {
    Comments? comments;

    Map<String, dynamic> response =
        await ApiService().request('comments/$slug', 'GET', {}, true);

    if (response['comments']['data'] is List<dynamic>) {
      comments = Comments.fromJson(response['comments']['data']);
    }

    return comments;
  }

  static Future delete(int id) async {
    Map<String, dynamic> response =
        await ApiService().request('comments/$id', 'DELETE', {}, true);
    return response;
  }
}
