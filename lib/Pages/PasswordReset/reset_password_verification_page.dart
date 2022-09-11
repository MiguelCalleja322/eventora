import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/reset_password_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResetPasswordVerificationPage extends StatefulWidget {
  ResetPasswordVerificationPage({Key? key, required this.mobile})
      : super(key: key);
  late String mobile;
  @override
  State<ResetPasswordVerificationPage> createState() =>
      _ResetPasswordVerificationPageState();
}

class _ResetPasswordVerificationPageState
    extends State<ResetPasswordVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  late FocusNode otpNode = FocusNode();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Verification',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                onChanged: (value) => value,
                textAlign: TextAlign.left,
                letterSpacing: 1.0,
                label: 'OTP',
                controller: otpController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                focusNode: otpNode,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
                onPressed: () {
                  resetPasswordVerification(context);
                },
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
                text: 'Request OTP',
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPasswordVerification(context) async {
    if (otpController.text.isEmpty) {
      otpNode.requestFocus();
      return;
    }

    Map<String, dynamic> rpvData = {
      'mobile': widget.mobile,
      'otp': otpController.text,
    };

    Map<String, dynamic> response =
        await ResetPassword.resetPasswordVerification(rpvData);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']);
      return;
    }

    if (response['access_token'] != null) {
      await dotenv.load(fileName: ".env");
      final String? storageKey = dotenv.env['STORAGE_KEY'];
      await StorageSevice()
          .write(StorageSevice.storageKey, response['access_token']);
      CustomFlutterToast.showErrorToast(response['message']);

      Navigator.pushNamed(context, '/reset_password');
      return;
    }

    if (response['user_verification'] != null) {
      CustomFlutterToast.showErrorToast(response['user_verification']);
      return;
    }
  }
}
