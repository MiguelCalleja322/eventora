import 'package:eventora/services/api_services.dart';

class AppointmentController {
  Future store(Map<String, dynamic> appointmentData) async {
    Map<String, dynamic> response = await ApiService()
        .request('appointments', 'POST', appointmentData, true);
    return response;
  }

  Future delete(int id) async {
    Map<String, dynamic> response =
        await ApiService().request('appointments/$id', 'DELETE', {}, true);
    return response;
  }
}
