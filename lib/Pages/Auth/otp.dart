import 'dart:async';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../controllers/auth_controller.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // ignore: unused_field
  late Timer timer;
  int start = 0;
  final TextEditingController _otpController = TextEditingController();
  bool screenLoading = false;
  late String role = '';

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getRole();
      startTimer();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screenLoading
          ? const LoadingPage()
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/otp.png'),
                          radius: 90.0,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                              fontSize: 26.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(
                          height: 40.0,
                        ),
                        const Text(
                          'Please enter the verification code sent to your email.',
                          style: TextStyle(fontSize: 14.0, letterSpacing: 2.0),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        CustomTextField(
                          onChanged: (value) => value,
                          textAlign: TextAlign.center,
                          letterSpacing: 10.0,
                          controller: _otpController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(6)
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              verify(context);
                            },
                            style: OutlinedButton.styleFrom(
                                primary: const Color(0xFFF7F8FB),
                                backgroundColor: const Color(0xFF114F5A),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)))),
                            child: const Text(
                              'Verify',
                              style:
                                  TextStyle(fontSize: 15.0, letterSpacing: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextButton(
                            onPressed: () {
                              if (start == 0) {
                                startTimer();
                                return;
                              } else {
                                CustomFlutterToast.showOkayToast(
                                    'Please wait for a minute to request for new OTP');
                              }
                            },
                            child: Text(
                              'RESEND OTP in $start secs',
                              style: const TextStyle(letterSpacing: 1.2),
                            ))
                        // Image.asset('')
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void requestNewOtp() async {
    await AuthController().requestNewOTP();
    CustomFlutterToast.showOkayToast('New OTP was sent to your number.');
  }

  void verify(context) async {
    setState(() {
      screenLoading = true;
    });

    Map<String, dynamic> isVerified;

    Map<String, String> otp = {'otp': _otpController.text};

    isVerified = await AuthController().verifyAccount(otp);

    if (isVerified['error_otp'] != null) {
      CustomFlutterToast.showErrorToast(isVerified['error_otp']);
    }

    if (isVerified['is_verified'] == true) {
      CustomFlutterToast.showOkayToast(isVerified['message']);
      if (role == 'organizer') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/user_preference');
      }
    }

    setState(() {
      screenLoading = false;
    });
  }

  void startTimer() {
    requestNewOtp();
    start = 60;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (start == 0) {
                timer.cancel();
              } else {
                start = start - 1;
              }
            }));
  }
}
