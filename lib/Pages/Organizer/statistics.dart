import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../Widgets/custom_appbar.dart';
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
  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

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
      fetchCloudFrontUri();
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
      appBar: CustomAppBar(
        title: 'Statistics',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => fetchStatistics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                              slug: mostLiked!['slug'],
                              bgColor: int.parse(mostLiked!['bgcolor']),
                              imageUrl:
                                  cloudFrontUri! + mostLiked!['images'][0],
                              eventType: mostLiked!['event_type'],
                              title: mostLiked!['title'],
                              description: mostLiked!['description'],
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      mostLiked!['schedule_start'])))),
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
                              slug: mostInteresting!['slug'],
                              bgColor: int.parse(mostInteresting!['bgcolor']),
                              imageUrl: cloudFrontUri! +
                                  mostInteresting!['images'][0],
                              eventType: mostInteresting!['event_type'],
                              title: mostInteresting!['title'],
                              description: mostInteresting!['description'],
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      mostInteresting!['schedule_start']))),
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
                              slug: mostAttendees!['slug'],
                              bgColor: int.parse(mostAttendees!['bgcolor']),
                              imageUrl:
                                  cloudFrontUri! + mostAttendees!['images'][0],
                              eventType: mostAttendees!['event_type'],
                              title: mostAttendees!['title'],
                              description: mostAttendees!['description'],
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      mostAttendees!['schedule_start']))),
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
