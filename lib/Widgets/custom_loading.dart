import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitCircle(
            color: Colors.white,
            size: 50.0,
          ),
          SizedBox(height: 15),
          Text(
            'Loading...',
            style: TextStyle(
                color: Colors.white, fontSize: 16.0, letterSpacing: 2.0),
          )
        ],
      ),
    );
  }

  // void processData() async {
  //   if (widget.function == 'login') {
  //     widget._isAuthenticated = await AuthController().login(widget.data!);
  //     if (widget._isAuthenticated!['is_verified'] == 0) {
  //       // ignore: use_build_context_synchronously
  //       await Navigator.pushReplacementNamed(context, '/otp_page');
  //     } else {
  //       if (widget._isAuthenticated!['message'] != null) {
  //         // ignore: use_build_context_synchronously
  //         await Navigator.pushReplacementNamed(context, '/', arguments: {
  //           'isAuthenticated': widget._isAuthenticated!['message']
  //         });
  //       } else {
  //         // ignore: use_build_context_synchronously
  //         await Navigator.pushReplacementNamed(context, '/feature_page');
  //       }
  //     }
  //   } else if (widget.function == 'otp') {
  //
  //   } else if (widget.function == 'signup') {
  //     await AuthController().signup(widget.data!);
  //     // ignore: use_build_context_synchronously
  //     await Navigator.pushReplacementNamed(context, '/otp_page');
  //   }
  // }
}
