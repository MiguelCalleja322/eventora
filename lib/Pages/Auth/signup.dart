// ignore_for_file: must_be_immutable

import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import '../../Widgets/custom_loading.dart';
import '../../Widgets/custom_textfield.dart';

import '../../controllers/auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../utils/email_validation.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);
  // ignore: unused_field
  late Map<String, dynamic>? _isAuthenticated = {};
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void dispose() {
    super.dispose();
  }

  DateTime birthdate = DateTime.now();
  late String formattedBirthDate = DateFormat('yyyy-MM-dd').format(birthdate);
  late int isAgeOver18 = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthdate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != birthdate) {
      setState(() {
        birthdate = picked;
        formattedBirthDate = DateFormat('yyyy-MM-dd').format(birthdate);
        final difference = DateTime.now().difference(birthdate);
        isAgeOver18 = (difference.inDays / 365).floor();
      });
    }
  }

  String roleValue = 'user';

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool screenLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return screenLoading
        ? const LoadingPage()
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Eventora',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 40.0),
                        ),
                        const SizedBox(height: 70),
                        CustomTextField(
                          onChanged: (value) => value,
                          textAlign: TextAlign.left,
                          letterSpacing: 1.0,
                          label: 'Name',
                          controller: _nameController,
                          focusNode: _nameFocus,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z A-Z]')),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          onChanged: (value) => value,
                          label: 'Email',
                          controller: _emailController,
                          focusNode: _emailFocus,
                          validator: (value) =>
                              EmailServiceChecker().isEmailValid(value!),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                onChanged: (value) => value,
                                textAlign: TextAlign.left,
                                letterSpacing: 1.0,
                                label: 'Username',
                                controller: _usernameController,
                                focusNode: _usernameFocus,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9]'))
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: CustomTextField(
                                  onChanged: (value) => value,
                                  textAlign: TextAlign.left,
                                  letterSpacing: 1.0,
                                  label: 'Mobile',
                                  controller: _mobileController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  focusNode: _mobileFocus),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                            obscureText: true,
                            onChanged: (value) => value,
                            label: 'Password',
                            controller: _passwordController,
                            focusNode: _passwordFocus),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                            obscureText: true,
                            onChanged: (value) => value,
                            label: 'Password Confirmation',
                            controller: _passwordConfirmController,
                            focusNode: _passwordConfirmFocus),
                        const SizedBox(height: 15),
                        FlutterPwValidator(
                          controller: _passwordController,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          width: 400,
                          height: 150,
                          onSuccess: () {},
                          onFail: () {
                            _passwordFocus.requestFocus();
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Are you a / an?'),
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownButton<String>(
                              value: roleValue,
                              elevation: 16,
                              style: const TextStyle(color: Color(0xFF114F5A)),
                              underline: Container(
                                height: 2,
                                color: const Color(0xFF114F5A),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  roleValue = newValue!;
                                });
                              },
                              items: <String>[
                                'user',
                                'organizer'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: const Text('Birthdate'),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                                child: Text(
                                    "${birthdate.toLocal()}".split(' ')[0])),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signup(context);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                                primary: const Color(0xFFF7F8FB),
                                backgroundColor: const Color(0xFF114F5A),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)))),
                            child: const Text(
                              'Signup',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/'),
                            child: const Text('Click Here to Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void signup(context) async {
    if (mounted) {
      if (_nameController.text.isEmpty) {
        return _nameFocus.requestFocus();
      }

      if (_emailController.text.isEmpty) {}

      if (_passwordController.text.isEmpty) {
        return _passwordFocus.requestFocus();
      }

      if (_passwordConfirmController.text.isEmpty) {
        return _passwordConfirmFocus.requestFocus();
      }

      if (_usernameController.text.isEmpty) {
        return _usernameFocus.requestFocus();
      }

      if (_mobileController.text.isEmpty) {
        return _mobileFocus.requestFocus();
      }

      if (isAgeOver18 < 18) {
        Fluttertoast.showToast(
            msg: 'Age must be over 18',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
      }

      // ignore: unnecessary_null_comparison
      if (roleValue == null) {
        Fluttertoast.showToast(
            msg: 'You must have a role.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        return;
      }

      if (_passwordController.text != _passwordConfirmController.text) {
        Fluttertoast.showToast(
            msg: 'Password did not match!',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);

        return;
      }

      Map<String, String> signupCredentials = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'username': _usernameController.text,
        'mobile': _mobileController.text,
        'birthdate': formattedBirthDate,
        'type': roleValue,
      };

      setState(() {
        screenLoading = true;
      });

      widget._isAuthenticated =
          await AuthController().signup(signupCredentials);

      setState(() {
        screenLoading = false;
      });

      Navigator.pushReplacementNamed(
        context,
        '/otp_page',
      );
    }
  }
}
