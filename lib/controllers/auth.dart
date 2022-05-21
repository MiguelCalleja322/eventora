import 'package:eventora/services/api_services.dart';
import 'package:http/http.dart' as http;

class AuthController {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // RxBool loginLoading = false.obs;

  bool loginLoading = false;
  bool withToken = false;

  Future login(Map<String, String?> loginData) async {
    loginLoading = true;
    Map<String, dynamic> response =
        await ApiService().request('login', 'POST', loginData, withToken);
    if (response != null) {
      print(response['access_token']);
    }
  }

  Future<bool> checkServer(String? apiUrl) async {
    Uri uri = Uri.parse('${apiUrl}ping');
    try {
      http.Response response = await http.get(uri);
      // ignore: unnecessary_null_comparison
      return response != null;
    } catch (e) {
      return false;
    }
  }
}
