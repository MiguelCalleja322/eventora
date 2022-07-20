// ignore_for_file: must_be_immutable

import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:ionicons/ionicons.dart';
import '../../Widgets/custom_button.dart';
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
  DateTime birthdate = DateTime.now();
  late int isAgeOver18 = 0;

  String roleValue = 'user';

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  bool screenLoading = false;
  final _formKey = GlobalKey<FormState>();

  late DateTime currentMaxDate = DateTime.now();
  late DateTime newMaxDate = DateTime(
      currentMaxDate.year - 18, currentMaxDate.month, currentMaxDate.day);
  @override
  void dispose() {
    _birthdateController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _websiteController.dispose();
    screenLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return screenLoading
        ? const LoadingPage()
        : Scaffold(
            appBar: CustomAppBar(
              title: 'Signup',
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        CustomTextField(
                          onChanged: (value) => value,
                          textAlign: TextAlign.left,
                          letterSpacing: 1.0,
                          label: 'Website',
                          controller: _websiteController,
                          focusNode: _websiteFocus,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z A-Z]')),
                          ],
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
                                  label: 'Mobile: +974',
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: CustomButton(
                                  backgroundColor: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10.0),
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(1960, 1, 1),
                                        maxTime: newMaxDate, onConfirm: (date) {
                                      var inputFormat =
                                          DateFormat('yyyy-MM-dd');
                                      setState(() {
                                        _birthdateController.text =
                                            inputFormat.format(date);

                                        final difference =
                                            DateTime.now().difference(date);
                                        isAgeOver18 =
                                            (difference.inDays / 365).floor();
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                  padding: const EdgeInsets.all(0.0),
                                  alignment: Alignment.center,
                                  isIcon: true,
                                  icon: Ionicons.calendar_outline,
                                  // text: _birthdateController.text.isEmpty
                                  //     ? 'Birthdate'
                                  //     : _birthdateController.text,
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(_birthdateController.text)))
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          backgroundColor: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10.0),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signup(context);
                            }
                          },
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          text: 'Signup',
                          elevation: 0,
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
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: 'Age must be over 18',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        return;
      }

      if (_websiteController.text.isEmpty) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: 'Website is required',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        return;
      }
      // ignore: unnecessary_null_comparison
      if (roleValue == null) {
        Fluttertoast.cancel();
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
        Fluttertoast.cancel();
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
        'website': _websiteController.text,
        'mobile': '+974${_mobileController.text}',
        'birthdate': _birthdateController.text,
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
