import 'package:email_validator/email_validator.dart';
import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import '../../Widgets/custom_textfield.dart';
import '../../controllers/auth.dart';
import '../../utils/email_validation.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorEmail = '';
  final _formKey = GlobalKey<FormState>();
  // Timer? _debounce;

  @override
  // void dispose() {
  //   _debounce?.cancel();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Eventora',
                  style: TextStyle(color: Colors.grey[800], fontSize: 40.0),
                ),
                const SizedBox(height: 70),
                CustomTextFormField(
                  focusNode: emailFocus,
                  obscureText: false,
                  validator: (value) =>
                      EmailServiceChecker().isEmailValid(value!),
                  label: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  focusNode: emailFocus,
                  obscureText: true,
                  validator: (value) =>
                      EmailServiceChecker().isEmailValid(value!),
                  label: 'Password',
                  controller: passwordController,
                ),
                const SizedBox(height: 15),
                Text(errorEmail),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(context);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                              primary: Colors.grey[900],
                              backgroundColor: Colors.grey[100],
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: const Text('Click Here to Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(context) async {
    if (errorEmail != '') {
      return emailFocus.requestFocus();
    }

    if (emailController.text.isEmpty) {
      return emailFocus.requestFocus();
    }

    if (passwordController.text.isEmpty) {
      return emailFocus.requestFocus();
    }

    Map<String, String> loginCredentials = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    // AuthController().login(loginCredentials);
  }
}
