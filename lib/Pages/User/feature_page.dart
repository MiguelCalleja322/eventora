import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_events_card.dart';
import 'package:eventora/Widgets/custom_featured_events.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  late Map<String, dynamic>? features = {};
  late bool loading = false;
  late List<dynamic>? featuredUpcoming = [];
  late List<dynamic>? featuredOrganizers = [];
  late List<dynamic>? featuredEvents = [];
  late Map<String, dynamic>? isFollowed = {};
  late int? followed = 0;
  late List<String> featureEventsImages = [];
  late String? cloudFrontUri = '';
  late String message = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  Future<void> fetchFeatures() async {
    features = await FeaturePageController().getFeatures();

    if (features!.isNotEmpty) {
      setState(() {
        featuredOrganizers = features!['organizer'] ?? [];
        featuredUpcoming = features!['upcoming_events'] ?? [];
        featuredEvents = features!['events'] ?? [];
      });
    }
  }

  @override
  void initState() {
    if (mounted) {
      fetchFeatures();
      fetchCloudFrontUri();
    }
    super.initState();
  }

  @override
  void dispose() {
    features = {};
    loading = false;
    isFollowed = {};
    followed = 0;
    featureEventsImages = [];
    cloudFrontUri = '';
    message = '';
    featuredOrganizers = [];
    featuredUpcoming = [];
    featuredEvents = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return fetchFeatures();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Home',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 40.0)),
                  ),
                  SizedBox(
                    height: 40,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Featured Events',
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Divider(
                          color: Colors.grey[600],
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  featuredEvents!.isEmpty
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 132, 132, 132),
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                          child: SizedBox(
                            height: 150,
                            width: (MediaQuery.of(context).size.width),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'No Featured Events',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 85,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CarouselSlider.builder(
                              itemCount: featuredEvents!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomFeaturedEvents(
                                  imageUrl: cloudFrontUri! +
                                      featuredEvents![index]['images'][0],
                                  slug: featuredEvents![index]['slug'],
                                  bgColor: int.parse(
                                      featuredEvents![index]['bgcolor']),
                                  title: featuredEvents![index]['title'],
                                  scheduleStart:
                                      DateFormat('E, d MMM yyyy HH:mm').format(
                                          DateTime.parse(featuredEvents![index]
                                              ['schedule_start'])),
                                );
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
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hot Events',
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Divider(
                          color: Colors.grey[600],
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  featuredUpcoming!.isEmpty
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 132, 132, 132),
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                          child: SizedBox(
                            height: 150,
                            width: (MediaQuery.of(context).size.width),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'No Featured Events',
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 85,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CarouselSlider.builder(
                              itemCount: featuredUpcoming!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomFeaturedEvents(
                                  imageUrl: cloudFrontUri! +
                                      featuredUpcoming![index]['images'][0],
                                  slug: featuredUpcoming![index]['slug'],
                                  bgColor: int.parse(
                                      featuredUpcoming![index]['bgcolor']),
                                  title: featuredUpcoming![index]['title'],
                                  scheduleStart:
                                      DateFormat('E, d MMM yyyy HH:mm').format(
                                          DateTime.parse(
                                              featuredUpcoming![index]
                                                  ['schedule_start'])),
                                );
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
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Organizers',
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Divider(
                          color: Colors.grey[600],
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  featuredOrganizers!.isEmpty
                      ? SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 300,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CarouselSlider.builder(
                              itemCount: featuredOrganizers!.length,
                              itemBuilder: (context, index, realIndex) {
                                return CustomProfile(
                                    userId: featuredOrganizers![index]['id'],
                                    page: 'features',
                                    isFollowed: featuredOrganizers![index]
                                                ['followers']
                                            .isEmpty
                                        ? 0
                                        : featuredOrganizers![index]
                                            ['followers'][0]['is_followed'],
                                    follow: () => follow(
                                        featuredOrganizers![index]['username']),
                                    name: featuredOrganizers![index]['name'],
                                    username: featuredOrganizers![index]
                                        ['username'],
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
      if (mounted) {
        setState(() {
          followed = 1;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          followed = 0;
        });
      }
    }
  }

  void onPressedShareEvent(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().shareEvent(eventSlug);

    if (response['events'].isNotEmpty) {
      message = response['events'];
    } else {
      message = 'Something went wrong...';
    }

    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
    return;
  }

  void onPressedInterested(String? slug) async {
    Color? toastColor = Colors.grey[700];
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().interested(eventSlug);

    if (response['interested'] != null) {
      message = response['interested'];
      toastColor = Colors.grey[700];
    } else {
      message = 'Something went wrong...';
      toastColor = Colors.red[500];
    }

    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: toastColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
  }

  void onPressedSave(String? slug) async {
    Color? toastColor = Colors.grey[700];
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().saveEvent(eventSlug);

    if (response['message'] != null) {
      message = response['message'];
      toastColor = Colors.red[700];
    } else {
      message = response['events'];
      toastColor = Colors.grey[700];
    }

    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: toastColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
    return;
  }

  void onPressedLike(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    await EventController().like(eventSlug);
  }
}
