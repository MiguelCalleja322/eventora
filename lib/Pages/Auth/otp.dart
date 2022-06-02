import 'dart:async';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../controllers/auth.dart';

class OTPPage extends StatefulWidget {
  OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // ignore: unused_field
  late Timer _timer;
  int _start = 0;
  final TextEditingController _otpController = TextEditingController();
  bool screenLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screenLoading
          ? const Center(
              child: SpinKitCircle(
                color: Colors.white,
                size: 50.0,
              ),
            )
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 70.0, 30.0, 0),
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
                            // print('bayot si miguel');
                            // return;
                            verifyAccount(context);
                          },
                          style: OutlinedButton.styleFrom(
                              primary: const Color(0xFFF7F8FB),
                              backgroundColor: const Color(0xFF114F5A),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
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
                            if (_start == 0) {
                              startTimer();
                              return;
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'Please wait for a minute to request for new OTP',
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red[500],
                                  textColor: Colors.white,
                                  timeInSecForIosWeb: 3,
                                  toastLength: Toast.LENGTH_LONG,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            'RESEND OTP in ($_start) secs',
                            style: const TextStyle(letterSpacing: 1.2),
                          ))
                      // Image.asset('')
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void requestNewOtp() async {
    await AuthController().requestNewOTP();

    await Fluttertoast.showToast(
        msg: 'New OTP was sent to your email.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
    Fluttertoast.cancel();
  }

  void verifyAccount(context) async {
    if (mounted) {
      setState(() {
        screenLoading = true;
      });

      late Map<String, dynamic> isVerified;

      Map<String, String> otp = {'otp': _otpController.text};
      if (!mounted) return;

      isVerified = await AuthController().verifyAccount(otp);

      // print(widget._isVerified);

      if (isVerified['is_verified'] == true) {
        await Fluttertoast.showToast(
            msg: isVerified['message'],
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[700],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        print('bayot miguel');
        Future.delayed(Duration(seconds: 3), () {
          Fluttertoast.cancel();
          Navigator.pushReplacementNamed(context, '/feature_page');
        });
        // return;
      }

      setState(() {
        screenLoading = false;
      });

      Fluttertoast.showToast(
          msg: isVerified['message'],
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      return;
    } else {
      return;
    }
  }

  void startTimer() {
    requestNewOtp();
    _start = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start == 0) {
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
  }
}
