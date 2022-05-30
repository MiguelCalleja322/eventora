import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../controllers/auth.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key, required this.data, required this.function})
      : super(key: key);

  late Map<String, String>? data;
  late String? function;
  late Map<String, dynamic>? _isAuthenticated = {};

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void processData() async {
    if (widget.function == 'login') {
      widget._isAuthenticated = await AuthController().login(widget.data!);
      if (widget._isAuthenticated!['message'] != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/', arguments: {
          'isAuthenticated': widget._isAuthenticated!['message']
        });
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/feature_page');
      }
    } else if (widget.function == 'signup') {
      await AuthController().signup(widget.data!);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/feature_page');
    }
  }

  @override
  void initState() {
    super.initState();
    processData();
  }

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
}
