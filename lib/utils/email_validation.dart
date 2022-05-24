import 'package:email_validator/email_validator.dart';

class EmailServiceChecker {
  String isEmailValid(String email) {
    if (email.isEmpty) {
      return "Email can not be empty";
    } else if (!EmailValidator.validate(email, true)) {
      return "Invalid email address";
    } else {
      return "";
    }
  }
}
