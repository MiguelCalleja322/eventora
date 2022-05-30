import 'package:eventora/services/api_services.dart';

class AuthController {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // RxBool loginLoading = false.obs;

  Future login(Map<String, String?> loginData) async {
    Map<String, dynamic> response =
        await ApiService().request('login', 'POST', loginData, false);
    return response;
  }

  Future signup(Map<String, String?> signupData) async {
    Map<String, dynamic> response =
        await ApiService().request('signup', 'POST', signupData, false);
    return response;
  }

  // Future<bool> checkServer(String? apiUrl) async {
  //   Uri uri = Uri.parse('${apiUrl}ping');
  //   try {
  //     http.Response response = await http.get(uri);
  //     // ignore: unnecessary_null_comparison
  //     return response != null;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
