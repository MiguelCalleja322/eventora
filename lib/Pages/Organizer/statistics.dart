import 'package:eventora/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:eventora/Widgets/custom_events_card.dart';
import 'package:eventora/controllers/user_controller.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Map<String, dynamic>? statistics = {};
  late bool loading = false;
  late Map<String, dynamic>? mostLiked = {};
  late Map<String, dynamic>? mostAttendees = {};
  late Map<String, dynamic>? mostInteresting = {};
  late Map<String, dynamic>? isFollowed = {};
  late int? test = 0;

  Future<void> fetchStatistics() async {
    statistics = await StatisticsController().getStatistics();

    if (statistics!.isNotEmpty) {
      setState(() {
        mostLiked = statistics!['most_liked'] ?? {};
        mostInteresting = statistics!['most_interesting'] ?? {};
        mostAttendees = statistics!['most_attendees'] ?? {};
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => fetchStatistics(),
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
                      child: Text('Statistics',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 40.0)),
                    ),
                    SizedBox(
                      height: 40,
                      child: Divider(
                        color: Colors.grey[600],
                      ),
                    ),
                    const Text(
                      'Most Liked Event',
                      style: TextStyle(
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    mostLiked!.isEmpty
                        ? SpinKitCircle(
                            size: 50.0,
                            color: Colors.grey[700],
                          )
                        : SizedBox(
                            height: 600,
                            child: CustomEventCard(
                                images: mostLiked!['images'],
                                title: mostLiked!['title'].toString(),
                                description:
                                    mostLiked!['description'].toString(),
                                schedule: mostLiked!['schedule'].toString(),
                                fees: mostLiked!['fees'].toString(),
                                likes:
                                    mostLiked!['events_likes_count'].toString(),
                                interested: '',
                                attendees: '',
                                organizer: '',
                                onPressedLike: onPressedAttend,
                                onPressedShare: onPressedAttend,
                                onPressedInterested: onPressedInterested,
                                onPressedSave: onPressedSave)),
                    const Text(
                      'Most Interesting Event',
                      style: TextStyle(
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    mostInteresting!.isEmpty
                        ? SpinKitCircle(
                            size: 50.0,
                            color: Colors.grey[700],
                          )
                        : SizedBox(
                            height: 600,
                            child: CustomEventCard(
                                images: mostInteresting!['images'],
                                title: mostInteresting!['title'].toString(),
                                description:
                                    mostInteresting!['description'].toString(),
                                schedule:
                                    mostInteresting!['schedule'].toString(),
                                fees: mostInteresting!['fees'].toString(),
                                likes: '',
                                interested: mostInteresting!['interests_count']
                                    .toString(),
                                attendees: '',
                                organizer: '',
                                onPressedLike: onPressedAttend,
                                onPressedShare: onPressedAttend,
                                onPressedInterested: onPressedInterested,
                                onPressedSave: onPressedSave)),
                    const Text(
                      'Most Attended Event',
                      style: TextStyle(
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    mostAttendees!.isEmpty
                        ? SpinKitCircle(
                            size: 50.0,
                            color: Colors.grey[700],
                          )
                        : SizedBox(
                            height: 600,
                            child: CustomEventCard(
                                images: mostAttendees!['images'],
                                title: mostAttendees!['title'].toString(),
                                description:
                                    mostAttendees!['description'].toString(),
                                schedule: mostAttendees!['schedule'].toString(),
                                fees: mostAttendees!['fees'].toString(),
                                likes: '',
                                interested: '',
                                attendees: mostAttendees!['attendees_count']
                                    .toString(),
                                organizer: '',
                                onPressedLike: onPressedAttend,
                                onPressedShare: onPressedAttend,
                                onPressedInterested: onPressedInterested,
                                onPressedSave: onPressedSave)),
                  ],
                ),
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
