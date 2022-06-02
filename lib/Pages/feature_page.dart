import 'package:eventora/Widgets/custom_profile.dart';
import 'package:flutter/material.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Text('Features',
                style: TextStyle(color: Colors.grey[800], fontSize: 40.0)),
            SizedBox(
              height: 40,
              child: Divider(
                color: Colors.grey[600],
              ),
            ),
            const Text(
              'Most Followed Organizers',
              style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const CustomProfile(),
          ],
        ),
      ),
    ));
  }
}
