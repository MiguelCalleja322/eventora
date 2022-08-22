import 'package:eventora/models/user.dart';
import 'package:eventora/services/api_services.dart';

class UserController {
  static Future follow(Map<String, String?> username) async {
    Map<String, dynamic> response =
        await ApiService().request('follow', 'POST', username, true);

    return response;
  }

  static Future<User?> show(String username) async {
    User? user;
    Map<String, dynamic> response =
        await ApiService().request('user/show/$username', 'GET', {}, true);

    user = User.fromJson(response['user']);

    return user;
  }
}
