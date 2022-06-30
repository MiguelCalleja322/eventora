// ignore_for_file: must_be_immutable

import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Widgets/custom_loading.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/email_validation.dart';
import '../../utils/secure_storage.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  late Map<String, dynamic>? _isAuthenticated = {};

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool screenLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _redirectIfUserIsLogged() async {
    await dotenv.load(fileName: ".env");
    final String storageKey = dotenv.env['STORAGE_KEY'] ?? '';

    String? bearerToken = await StorageSevice().read(storageKey) ?? '';

    if (bearerToken.isNotEmpty && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _redirectIfUserIsLogged();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenLoading
          ? const LoadingPage()
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.height),
                    width: (MediaQuery.of(context).size.width),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Eventora',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 40.0),
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
                            focusNode: passwordFocus,
                            obscureText: true,
                            label: 'Password',
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                          ),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
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
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/signup'),
                            child: const Text('Click Here to Signup'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void login(context) async {
    if (emailController.text.isEmpty) {
      return emailFocus.requestFocus();
    }

    if (passwordController.text.isEmpty) {
      return emailFocus.requestFocus();
    }

    setState(() {
      screenLoading = true;
    });

    Map<String, String> loginCredentials = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    widget._isAuthenticated = await AuthController().login(loginCredentials);

    setState(() {
      screenLoading = false;
    });

    if (widget._isAuthenticated!['is_verified'] == 0) {
      await Navigator.pushReplacementNamed(context, '/otp_page');
    } else {
      if (widget._isAuthenticated!['message'] != null) {
        Fluttertoast.showToast(
            msg: widget._isAuthenticated!['message'],
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
      } else {
        await Navigator.pushReplacementNamed(context, '/home');
      }
    }

    return;
  }
}
