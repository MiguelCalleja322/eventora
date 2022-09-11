import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:eventora/controllers/reset_password_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController passwordConfirmController =
      TextEditingController();

  late FocusNode passwordNode = FocusNode();
  late FocusNode passwordConfirmNode = FocusNode();

  @override
  void dispose() {
    passwordConfirmController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reset Password',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                focusNode: passwordNode,
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
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                focusNode: passwordConfirmNode,
                obscureText: true,
                label: 'Confirm Password',
                controller: passwordConfirmController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              FlutterPwValidator(
                controller: passwordController,
                minLength: 8,
                uppercaseCharCount: 1,
                numericCharCount: 1,
                specialCharCount: 1,
                width: 400,
                height: 150,
                onSuccess: () {},
                onFail: () {
                  passwordNode.requestFocus();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
                onPressed: () {
                  resetPassword(context);
                },
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
                text: 'Verify',
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(context) async {
    if (passwordController.text.isEmpty) {
      passwordNode.requestFocus();
      return;
    }

    if (passwordConfirmController.text.isEmpty) {
      passwordConfirmNode.requestFocus();
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      CustomFlutterToast.showErrorToast('Entered password did not match.');
    }

    Map<String, dynamic> rpData = {'password': passwordController.text};

    Map<String, dynamic> response = await ResetPassword.resetPassword(rpData);

    if (response['password'] != null) {
      CustomFlutterToast.showOkayToast(response['password']);
    }
  }
}
