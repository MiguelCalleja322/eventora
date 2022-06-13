import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:flutter/material.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  late Map<String, dynamic>? features = {};
  late bool loading = false;
  late List? featuredUsers = [];
  void fetchFeatures() async {
    setState(() {
      loading = true;
    });

    features = await FeaturePageController().getFeatures();

    featuredUsers = features!['user'];

    featuredUsers!.map((e) {
      print(e['name']);
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFeatures();
  }

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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Features',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 40.0)),
                  ],
                ),
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
                // ListView(scrollDirection: Axis.horizontal, children: [
                //   CustomProfile(
                //     image: features!['user']['avatar'],
                //     name: features!['user']['name'],
                //     followers: features!['user']['followers_count'],
                //     followings: features!['user']['following_count'],
                //   )
                // ]),
                const Text(
                  'Most Followed Users',
                  style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                // const CustomProfile(),
                const Text(
                  'Most Visited Events',
                  style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
