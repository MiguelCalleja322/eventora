import 'package:eventora/services/api_services.dart';

class AuthController {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // RxBool loginLoading = false.obs;

  bool loginLoading = false;

  Future login(Map<String, String?> loginData) async {
    loginLoading = true;
    Map<String, dynamic> response =
        await ApiService().request('login', 'POST', loginData, false);
  }

  Future signup(Map<String, String?> signupData) async {
    loginLoading = true;
    Map<String, dynamic> response =
        await ApiService().request('signup', 'POST', signupData, false);
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
