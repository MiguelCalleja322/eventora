import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  late Map<String, dynamic>? features = {};
  late bool loading = false;
  late List<dynamic>? featuredUsers = [];
  late List<dynamic>? featuredOrganizers = [];

  void fetchFeatures() async {
    features = await FeaturePageController().getFeatures();

    setState(() {
      featuredOrganizers = features!['organizer'];
      featuredUsers = features!['user'];
    });

    print(featuredOrganizers);
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
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Features',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 40.0)),
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
                  featuredOrganizers!.isEmpty
                      ? SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: CarouselSlider.builder(
                              itemCount: featuredOrganizers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return SizedBox(
                                    width: (MediaQuery.of(context).size.width),
                                    child: CustomProfile(
                                        // image: featuredUsers![index],
                                        name: featuredOrganizers![index]
                                            ['name'],
                                        followers: featuredOrganizers![index]
                                                ['followers_count']
                                            .toString(),
                                        followings: featuredOrganizers![index]
                                                ['following_count']
                                            .toString(),
                                        events: featuredOrganizers![index]
                                                ['events_count']
                                            .toString(),
                                        role: 'organizer'));
                              },
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 2),
                              )),
                        ),
                  const Text(
                    'Most Followed Users',
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  featuredOrganizers!.isEmpty
                      ? SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: CarouselSlider.builder(
                              itemCount: featuredUsers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return SizedBox(
                                    width: (MediaQuery.of(context).size.width),
                                    child: CustomProfile(
                                      // image: featuredUsers![index],
                                      name: featuredUsers![index]['name'],
                                      followers: featuredUsers![index]
                                              ['followers_count']
                                          .toString(),
                                      followings: featuredUsers![index]
                                              ['following_count']
                                          .toString(),
                                      events: featuredUsers![index]
                                              ['events_count']
                                          .toString(),
                                      role: 'user',
                                    ));
                              },
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 5),
                              )),
                        ),
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
      ),
    );
  }
}
