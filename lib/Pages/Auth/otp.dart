import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPPage extends StatefulWidget {
  OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Verification Code',
                  style: TextStyle(
                      fontSize: 26.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Please enter the verification code sent to your email.',
                  style: TextStyle(fontSize: 14.0, letterSpacing: 2.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomTextField(
                  onChanged: (value) => value,
                  textAlign: TextAlign.center,
                  letterSpacing: 10.0,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(6)
                  ],
                )
                // Image.asset('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
