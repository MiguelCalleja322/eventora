import 'package:eventora/services/api_services.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthController {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // RxBool loginLoading = false.obs;

  Future login(Map<String, String?> loginData) async {
    await dotenv.load(fileName: ".env");
    final String? storageKey = dotenv.env['STORAGE_KEY'];

    Map<String, dynamic> response =
        await ApiService().request('login', 'POST', loginData, false);

    if (response['access_token'] != null) {
      await StorageSevice().write(storageKey!, response['access_token']);
    }

    return response;
  }

  Future signup(Map<String, String?> signupData) async {
    Map<String, dynamic> response =
        await ApiService().request('signup', 'POST', signupData, false);

    return response;
  }

  Future verifyAccount(Map<String, String?> otp) async {
    Map<String, dynamic> response =
        await ApiService().request('user/verify', 'PUT', otp, true);
    return response;
  }

  Future requestNewOTP() async {
    await ApiService().request('user/requestNewOTP', 'POST', {}, true);
  }

  verifyOTP(Map<String, String> otp) {}

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
