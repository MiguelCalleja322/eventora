import 'package:eventora/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:eventora/Widgets/custom_events_card.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/secure_storage.dart';

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
  late String? role = '';

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

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
    if (mounted) {
      getRole();
      fetchStatistics();
    }
    super.initState();
  }

  @override
  void dispose() {
    statistics = {};
    mostLiked = {};
    mostInteresting = {};
    mostAttendees = {};
    isFollowed = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => fetchStatistics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Statistics',
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
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: double.infinity,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CustomEventCard(
                              role: role,
                              slug: mostLiked!['slug'],
                              venue: mostLiked!['venue'].isEmpty
                                  ? 'To be posted'
                                  : '${mostLiked!['venue']['unit_no']} ${mostLiked!['venue']['street_no']} ${mostLiked!['venue']['street_name']} ${mostLiked!['venue']['street_name']} ${mostLiked!['venue']['country']} ${mostLiked!['venue']['state']} ${mostLiked!['venue']['city']} ${mostLiked!['venue']['zipcode']}',
                              registrationLink: mostLiked!['registration_link'],
                              eventType: mostLiked!['event_type'],
                              images: mostLiked!['images'],
                              title: mostLiked!['title'].toString(),
                              description: mostLiked!['description'].toString(),
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
                              onPressedSave: onPressedSave),
                        ),
                  SizedBox(
                    height: 40,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
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
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: double.infinity,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CustomEventCard(
                              role: role,
                              slug: mostInteresting!['slug'],
                              venue: mostInteresting!['venue'].isEmpty
                                  ? 'To be posted'
                                  : '${mostInteresting!['venue']['unit_no']} ${mostInteresting!['venue']['street_no']} ${mostInteresting!['venue']['street_name']} ${mostInteresting!['venue']['street_name']} ${mostInteresting!['venue']['country']} ${mostInteresting!['venue']['state']} ${mostInteresting!['venue']['city']} ${mostInteresting!['venue']['zipcode']}',
                              registrationLink:
                                  mostInteresting!['registration_link'],
                              eventType: mostInteresting!['event_type'],
                              images: mostInteresting!['images'],
                              title: mostInteresting!['title'].toString(),
                              description:
                                  mostInteresting!['description'].toString(),
                              schedule: mostInteresting!['schedule'].toString(),
                              fees: mostInteresting!['fees'].toString(),
                              likes: '',
                              interested: mostInteresting!['interests_count']
                                  .toString(),
                              attendees: '',
                              organizer: '',
                              onPressedLike: onPressedAttend,
                              onPressedShare: onPressedAttend,
                              onPressedInterested: onPressedInterested,
                              onPressedSave: onPressedSave),
                        ),
                  SizedBox(
                    height: 40,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
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
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: double.infinity,
                              maxWidth: (MediaQuery.of(context).size.width)),
                          child: CustomEventCard(
                              role: role,
                              slug: mostAttendees!['slug'],
                              venue: mostAttendees!['venue'].isEmpty
                                  ? 'To be posted'
                                  : '${mostAttendees!['venue']['unit_no']} ${mostAttendees!['venue']['street_no']} ${mostAttendees!['venue']['street_name']} ${mostAttendees!['venue']['street_name']} ${mostAttendees!['venue']['country']} ${mostAttendees!['venue']['state']} ${mostAttendees!['venue']['city']} ${mostAttendees!['venue']['zipcode']}',
                              registrationLink:
                                  mostAttendees!['registration_link'],
                              eventType: mostAttendees!['event_type'],
                              images: mostAttendees!['images'],
                              title: mostAttendees!['title'].toString(),
                              description:
                                  mostAttendees!['description'].toString(),
                              schedule: mostAttendees!['schedule'].toString(),
                              fees: mostAttendees!['fees'].toString(),
                              likes: '',
                              interested: '',
                              attendees:
                                  mostAttendees!['attendees_count'].toString(),
                              organizer: '',
                              onPressedLike: onPressedAttend,
                              onPressedShare: onPressedAttend,
                              onPressedInterested: onPressedInterested,
                              onPressedSave: onPressedSave),
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
  }

  void onPressedAttend() {}
  void onPressedInterested() {}
  void onPressedSave() {}
}
