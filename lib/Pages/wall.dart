import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Widgets/custom_events_card.dart';
import '../controllers/events_controller.dart';

class WallPage extends StatefulWidget {
  const WallPage({Key? key}) : super(key: key);

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  Map<String, dynamic>? feeds = {};
  late String? message = '';
  late bool? loading = false;
  late List<dynamic>? listOfFeeds = [];
  Future<void> fetchFeed() async {
    if (mounted) {
      feeds = await FeaturePageController().getFeed() ?? {};

      if (feeds!.isNotEmpty) {
        setState(() {
          listOfFeeds = feeds!['events'] ?? [];
        });
      }
    }
  }

  @override
  void initState() {
    if (mounted) {
      fetchFeed();
    }

    super.initState();
  }

  @override
  void dispose() {
    message = '';
    feeds = {};
    listOfFeeds = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => fetchFeed(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: listOfFeeds!.isEmpty
              ? const SizedBox(
                  child: Center(child: Text('There are no events posted.')))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfFeeds!.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        child: CustomEventCard(
                      venue:
                          '${listOfFeeds![index]['venue']['unit_no']} ${listOfFeeds![index]['venue']['street_no']} ${listOfFeeds![index]['venue']['street_name']} ${listOfFeeds![index]['venue']['country']} ${listOfFeeds![index]['venue']['state']} ${listOfFeeds![index]['venue']['city']} ${listOfFeeds![index]['venue']['zipcode']}',
                      registrationLink: listOfFeeds![index]
                          ['registration_link'],
                      title: listOfFeeds![index]['title'],
                      description: listOfFeeds![index]['description'],
                      schedule: listOfFeeds![index]['schedule'],
                      fees: listOfFeeds![index]['fees'].toString(),
                      likes:
                          listOfFeeds![index]['event_likes_count'].toString(),
                      interested:
                          listOfFeeds![index]['interests_count'].toString(),
                      attendees:
                          listOfFeeds![index]['attendees_count'].toString(),
                      organizer: listOfFeeds![index]['user']['username'],
                      onPressedShare: () =>
                          onPressedShareEvent(listOfFeeds![index]['slug']),
                      onPressedInterested: () => onPressedInterested,
                      onPressedSave: () => onPressedSave,
                      onPressedLike: () =>
                          onPressedLike(listOfFeeds![index]['slug']),
                      images: listOfFeeds![index]['images'],
                      eventType: listOfFeeds![index]['event_type'],
                    ));
                  }),
        ),
      ),
    ));
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
        msg: message!,
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
        msg: message!,
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
        msg: message!,
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
