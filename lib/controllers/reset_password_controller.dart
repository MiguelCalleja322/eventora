import 'package:eventora/services/api_services.dart';

class ResetPassword {
  static Future resetPasswordRequest(Map<String, dynamic> rprData) async {
    Map<String, dynamic> response = await ApiService()
        .request('reset_password_request', 'POST', rprData, false);
    return response;
  }

  static Future resetPasswordVerification(Map<String, dynamic> rpvData) async {
    Map<String, dynamic> response = await ApiService()
        .request('reset_password_verification', 'POST', rpvData, false);
    return response;
  }

  static Future resetPassword(Map<String, dynamic> rpData) async {
    Map<String, dynamic> response =
        await ApiService().request('reset_password', 'POST', rpData, true);
    return response;
  }
}
