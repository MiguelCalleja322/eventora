import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(
            color: Colors.grey[700],
            size: 50.0,
          ),
          const SizedBox(height: 15),
          Text(
            'Loading...',
            style: TextStyle(
                color: Colors.grey[700], fontSize: 16.0, letterSpacing: 2.0),
          )
        ],
      ),
    );
  }
}
