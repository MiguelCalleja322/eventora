import 'package:eventora/services/api_services.dart';

class PaymentController {
  Future pay(Map<String, dynamic> paymentData, String slug) async {
    Map<String, dynamic> response = await ApiService()
        .request('payment/stripe/$slug', 'POST', paymentData, true);
    return response;
  }
}
