import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/reset_password_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

class ResetPasswordRequestPage extends StatefulWidget {
  const ResetPasswordRequestPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordRequestPage> createState() =>
      _ResetPasswordRequestPageState();
}

class _ResetPasswordRequestPageState extends State<ResetPasswordRequestPage> {
  final TextEditingController mobileController = TextEditingController();
  late FocusNode mobileNode = FocusNode();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reset Password Request',
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
                label: 'Mobile: +974',
                controller: mobileController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                focusNode: mobileNode,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
                onPressed: () {
                  resetPasswordRequest(context);
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

  void resetPasswordRequest(context) async {
    if (mobileController.text.isEmpty) {
      mobileNode.requestFocus();
      return;
    }

    Map<String, dynamic> rprData = {
      'mobile': '+63${mobileController.text}',
    };

    Map<String, dynamic> response =
        await ResetPassword.resetPasswordRequest(rprData);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']);
    } else {
      CustomFlutterToast.showOkayToast(response['password_request']);
      Navigator.pushNamed(context, '/reset_password_verification', arguments: {
        'mobile': '+63${mobileController.text}',
      });
    }
  }
}
