import '../../Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  DateTime birthdate = DateTime.now();
  late String formattedBirthDate;
  late int isAgeOver18 = 0;

  // final difference = berlinWallFell.difference(dDay);
  // print(difference.inDays); // 16592

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

  String roleValue = 'User';

  final FocusNode nameFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode mobileFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode passwordConfirmFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eventora',
                  style: TextStyle(color: Colors.grey[800], fontSize: 40.0),
                ),
                const SizedBox(height: 70),
                CustomTextField(
                  onChanged: (value) => text = value,
                  label: 'Name',
                  controller: nameController,
                  focusNode: nameFocus,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  onChanged: (value) => text = value,
                  label: 'Email',
                  controller: emailController,
                  focusNode: emailFocus,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        onChanged: (value) => text = value,
                        label: 'Username',
                        controller: usernameController,
                        focusNode: usernameFocus,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: CustomTextField(
                          onChanged: (value) => text = value,
                          label: 'Mobile',
                          controller: mobileController,
                          focusNode: mobileFocus),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                    obscureText: true,
                    onChanged: (value) => text = value,
                    label: 'Password',
                    controller: passwordController,
                    focusNode: passwordFocus),
                const SizedBox(height: 15),
                CustomTextField(
                    obscureText: true,
                    onChanged: (value) => text = value,
                    label: 'Confirm Password',
                    controller: passwordConfirmController,
                    focusNode: passwordConfirmFocus),
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
                      items: <String>['User', 'Organizer']
                          .map<DropdownMenuItem<String>>((String value) {
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
                        child: Text("${birthdate.toLocal()}".split(' ')[0])),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      signup(context);
                    },
                    style: OutlinedButton.styleFrom(
                        primary: const Color(0xFFF7F8FB),
                        backgroundColor: const Color(0xFF114F5A),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
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
    );
  }

  void signup(context) async {
    if (nameController.text.isEmpty) {
      return nameFocus.requestFocus();
    }

    if (emailController.text.isEmpty) {
      return emailFocus.requestFocus();
    }

    if (passwordController.text.isEmpty) {
      return passwordFocus.requestFocus();
    }

    if (passwordConfirmController.text.isEmpty) {
      return passwordConfirmFocus.requestFocus();
    }

    if (usernameController.text.isEmpty) {
      return usernameFocus.requestFocus();
    }

    if (mobileController.text.isEmpty) {
      return mobileFocus.requestFocus();
    }

    if (isAgeOver18 < 18) {
      Fluttertoast.showToast(
          msg: 'Age must be over 18',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    if (roleValue == null) {
      Fluttertoast.showToast(
          msg: 'You must have a role.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      Fluttertoast.showToast(
          msg: 'Password did not match!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }
    Map<String, String> signupCredentials = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'username': usernameController.text,
      'mobile': mobileController.text,
      'birthdate': formattedBirthDate,
      'type': roleValue,
    };

    print(signupCredentials);

    // AuthController().signup(signupCredentials);
  }
}
