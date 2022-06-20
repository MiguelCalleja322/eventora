import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_events_card.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:eventora/controllers/user_controller.dart';
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
  late List<dynamic>? featuredEvents = [];
  late Map<String, dynamic>? isFollowed = {};
  late int? test = 0;

  void fetchFeatures() async {
    features = await FeaturePageController().getFeatures();

    if (features!.isNotEmpty) {
      setState(() {
        featuredOrganizers = features!['organizer'] ?? {};
        featuredUsers = features!['user'] ?? {};
        featuredEvents = features!['events'] ?? {};
      });
    }

    print(featuredUsers);
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height),
                  minWidth: (MediaQuery.of(context).size.width)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          height: 400,
                          child: CarouselSlider.builder(
                              itemCount: featuredOrganizers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomProfile(
                                    isFollowed: featuredOrganizers![index]
                                                ['followers']
                                            .isEmpty
                                        ? 0
                                        : featuredOrganizers![index]
                                            ['followers'][0]['is_followed'],
                                    follow: () => follow(
                                        featuredOrganizers![index]['username']),
                                    // image: featuredUsers![index],
                                    name: featuredOrganizers![index]['name'],
                                    followers: featuredOrganizers![index]
                                            ['followers_count']
                                        .toString(),
                                    followings: featuredOrganizers![index]
                                            ['following_count']
                                        .toString(),
                                    events: featuredOrganizers![index]
                                            ['events_count']
                                        .toString(),
                                    role: 'organizer');
                              },
                              options: CarouselOptions(
                                height: double.infinity,
                                autoPlay: true,
                                viewportFraction: 1,
                                reverse: false,
                                autoPlayInterval: const Duration(seconds: 5),
                                pauseAutoPlayOnTouch: true,
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
                          height: 400,
                          child: CarouselSlider.builder(
                              itemCount: featuredUsers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomProfile(
                                  isFollowed:
                                      featuredUsers![index]['followers'].isEmpty
                                          ? 0
                                          : featuredUsers![index]['followers']
                                              [0]['is_followed'],
                                  follow: () =>
                                      follow(featuredUsers![index]['username']),
                                  // image: featuredUsers![index],
                                  name: featuredUsers![index]['name'],
                                  followers: featuredUsers![index]
                                          ['followers_count']
                                      .toString(),
                                  followings: featuredUsers![index]
                                          ['following_count']
                                      .toString(),
                                  events: featuredUsers![index]['events_count']
                                      .toString(),
                                  role: 'user',
                                );
                              },
                              options: CarouselOptions(
                                height: double.infinity,
                                autoPlay: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 5),
                                pauseAutoPlayOnTouch: true,
                              )),
                        ),
                  const Text(
                    'Most Liked Events',
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  featuredEvents!.isEmpty
                      ? SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        )
                      : SizedBox(
                          height: 600,
                          child: CarouselSlider.builder(
                              itemCount: featuredUsers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomEventCard(
                                    title: featuredEvents![index]['title']
                                        .toString(),
                                    description: featuredEvents![index]
                                            ['description']
                                        .toString(),
                                    schedule: featuredEvents![index]['schedule']
                                        .toString(),
                                    fees: featuredEvents![index]['fees']
                                        .toString(),
                                    likes: featuredEvents![index]
                                            ['event_likes_count']
                                        .toString(),
                                    interested: featuredEvents![index]
                                            ['interests_count']
                                        .toString(),
                                    attendees: featuredEvents![index]
                                            ['attendees_count']
                                        .toString(),
                                    organizer: featuredEvents![index]['user']
                                            ['name']
                                        .toString(),
                                    onPressedAttend: onPressedAttend,
                                    onPressedInterested: onPressedInterested,
                                    onPressedSave: onPressedSave);
                              },
                              options: CarouselOptions(
                                height: double.infinity,
                                autoPlay: false,
                                viewportFraction: 1,
                              )),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void follow(String username) async {
    Map<String, String> followUser = {
      'username': username,
    };

    isFollowed = await UserController().follow(followUser);

    if (isFollowed!['is_followed'] == true) {
      setState(() {
        test = 1;
      });
    } else {
      setState(() {
        test = 0;
      });
    }
  }

  void onPressedAttend() {}
  void onPressedInterested() {}
  void onPressedSave() {}
}
