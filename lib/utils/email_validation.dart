import 'package:email_validator/email_validator.dart';

class EmailServiceChecker {
  String? isEmailValid(String email) {
    if (!EmailValidator.validate(email, true)) {
      return "Invalid email address";
    } else {
      return null;
    }
  }
}
