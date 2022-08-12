import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_error_message.dart';
import 'package:eventora/Widgets/custom_featured_events.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';
import 'package:eventora/models/features.dart';

import '../../Widgets/custom_appbar.dart';

class FeaturePage extends ConsumerStatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  FeaturePageState createState() => FeaturePageState();
}

final featuresProvider = FutureProvider.autoDispose<Features?>((ref) {
  return FeaturePageController.index();
});

class FeaturePageState extends ConsumerState<FeaturePage> {
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

  @override
  void initState() {
    if (mounted) {
      fetchCloudFrontUri();
    }
    super.initState();
  }

  @override
  void dispose() {
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
    final featuredData = ref.watch(featuresProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Features',
        height: 70,
        hideBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(featuresProvider),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: featuredData.when(
              data: (featured) {
                featuredUpcoming =
                    featured!.features![0].featuredUpcoming.events;
                featuredEvents = featured.features![0].featuredEvents.events;
                featuredOrganizers =
                    featured.features![0].featuredOrganizers.organizers;
                // print(featured!.features![0].upcoming.upcomingEvents[0].title);
                return SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Featured Events',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.0,
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
                          ? CustomErrorMessage(message: 'No Featured Event')
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 100,
                                  maxWidth:
                                      (MediaQuery.of(context).size.width)),
                              child: CarouselSlider.builder(
                                  itemCount: featuredEvents!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return CustomFeaturedEvents(
                                      imageUrl: cloudFrontUri! +
                                          featuredEvents![index].images[0],
                                      slug: featuredEvents![index].slug,
                                      bgColor: int.parse(
                                          featuredEvents![index].bgcolor),
                                      title: featuredEvents![index].title,
                                      scheduleStart:
                                          DateFormat('E, d MMM yyyy HH:mm')
                                              .format(DateTime.parse(
                                                  featuredEvents![index]
                                                      .scheduleStart)),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1,
                                    reverse: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 5),
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
                              'Upcoming Events',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.0,
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
                          ? CustomErrorMessage(message: 'No Upcoming Event')
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 100,
                                  maxWidth:
                                      (MediaQuery.of(context).size.width)),
                              child: CarouselSlider.builder(
                                  itemCount: featuredUpcoming!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return CustomFeaturedEvents(
                                      imageUrl: cloudFrontUri! +
                                          featuredUpcoming![index].images[0],
                                      slug: featuredUpcoming![index].slug,
                                      bgColor: int.parse(
                                          featuredUpcoming![index].bgcolor),
                                      title: featuredUpcoming![index].title,
                                      scheduleStart:
                                          DateFormat('E, d MMM yyyy HH:mm')
                                              .format(DateTime.parse(
                                                  featuredUpcoming![index]
                                                      .scheduleStart)),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1,
                                    reverse: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 5),
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
                                  letterSpacing: 1.0,
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
                          ? CustomErrorMessage(
                              message: 'No Organizers Featured')
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 300,
                                  maxWidth:
                                      (MediaQuery.of(context).size.width)),
                              child: CarouselSlider.builder(
                                  itemCount: featuredOrganizers!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return CustomProfile(
                                        image: featuredOrganizers![
                                                        index]
                                                    .avatar !=
                                                null
                                            ? '$cloudFrontUri${featuredOrganizers![index].avatar}'
                                            : 'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826',
                                        page: 'features',
                                        isFollowed:
                                            featuredOrganizers![
                                                        index]
                                                    .isFollowed
                                                    .isEmpty
                                                ? 0
                                                : featuredOrganizers![
                                                            index]
                                                        .isFollowed[
                                                    0]['is_followed'],
                                        follow:
                                            () =>
                                                follow(
                                                    featuredOrganizers![
                                                            index]
                                                        .username),
                                        name: featuredOrganizers![index].name,
                                        username:
                                            featuredOrganizers![index].username,
                                        followers: featuredOrganizers![
                                                index]
                                            .followersCount,
                                        followings: featuredOrganizers![
                                                index]
                                            .followingCount,
                                        events: featuredOrganizers![index]
                                            .eventsCount,
                                        role: 'organizer');
                                  },
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1,
                                    reverse: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 5),
                                    pauseAutoPlayOnTouch: true,
                                  )),
                            ),
                    ],
                  ),
                );
              },
              error: (_, __) => const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No Notes Created',
                    style: TextStyle(fontSize: 23, color: Colors.black54),
                  )),
              loading: () => Center(
                    child: SpinKitCircle(
                      size: 50.0,
                      color: Colors.grey[700],
                    ),
                  )),
        ),
      ),
    );
  }

  void follow(String username) async {
    Map<String, String> followUser = {
      'username': username,
    };

    isFollowed = await UserController.follow(followUser);

    ref.refresh(featuresProvider);
  }

  void onPressedShareEvent(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().shareEvent(eventSlug);

    if (response['events'].isNotEmpty) {
      CustomFlutterToast.showOkayToast(response['events']);
    } else {
      CustomFlutterToast.showErrorToast('Something went wrong...');
      message = 'Something went wrong...';
    }

    return;
  }

  void onPressedInterested(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().interested(eventSlug);

    if (response['interested'] != null) {
      CustomFlutterToast.showOkayToast(response['interested']);
    } else {
      CustomFlutterToast.showErrorToast('Something went wrong...');
    }
  }

  void onPressedSave(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().saveEvent(eventSlug);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']);
    } else {
      CustomFlutterToast.showOkayToast(response['events']);
    }

    return;
  }

  void onPressedLike(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    await EventController().like(eventSlug);
  }
}
