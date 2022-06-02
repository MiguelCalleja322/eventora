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
}
