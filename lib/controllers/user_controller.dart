import 'package:eventora/services/api_services.dart';

class UserController {
  Future follow(Map<String, String?> username) async {
    Map<String, dynamic> response =
        await ApiService().request('follow', 'POST', username, true);

    return response;
  }

  Future show(String username) async {
    Map<String, dynamic> response =
        await ApiService().request('user/show/$username', 'GET', {}, true);

    return response;
  }
}
