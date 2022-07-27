import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventora/models/statistics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../Widgets/custom_appbar.dart';
import '../../utils/secure_storage.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

final statisticsProvider = FutureProvider.autoDispose<Statistics?>((ref) {
  return StatisticsController.getStatistics();
});

class StatisticsPageState extends ConsumerState<StatisticsPage> {
  late List<dynamic>? mostLiked = [];
  late List<dynamic>? mostAttendees = [];
  late List<dynamic>? mostInteresting = [];
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

  @override
  void initState() {
    if (mounted) {
      fetchCloudFrontUri();
      getRole();
    }
    super.initState();
  }

  @override
  void dispose() {
    isFollowed = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statisticsData = ref.watch(statisticsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Statistics',
        hideBackButton: true,
      ),
      body: cloudFrontUri == ''
          ? SpinKitCircle(
              size: 50.0,
              color: Colors.grey[700],
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(statisticsProvider),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: statisticsData.when(
                        data: (statistics) {
                          mostLiked =
                              statistics!.statistics![0].mostLiked.events;
                          mostAttendees =
                              statistics.statistics![0].mostInteresting.events;
                          mostInteresting =
                              statistics.statistics![0].mostAttended.events;

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                            maxWidth: (MediaQuery.of(context)
                                                .size
                                                .width)),
                                        child: CustomEventCard(
                                            slug: mostLiked![0].slug,
                                            bgColor: int.parse(
                                                mostLiked![0].bgcolor),
                                            imageUrl: cloudFrontUri! +
                                                mostLiked![0].images[0],
                                            eventType: mostLiked![0].eventType,
                                            title: mostLiked![0].title,
                                            description:
                                                mostLiked![0].description,
                                            dateTime: DateFormat(
                                                    'E, d MMM yyyy HH:mm')
                                                .format(DateTime.parse(
                                                    mostLiked![0]
                                                        .scheduleStart)))),
                                const SizedBox(height: 15),
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
                                mostAttendees!.isEmpty
                                    ? SpinKitCircle(
                                        size: 50.0,
                                        color: Colors.grey[700],
                                      )
                                    : ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: double.infinity,
                                            maxWidth: (MediaQuery.of(context)
                                                .size
                                                .width)),
                                        child: CustomEventCard(
                                            slug: mostAttendees![0].slug,
                                            bgColor: int.parse(
                                                mostAttendees![0].bgcolor),
                                            imageUrl: cloudFrontUri! +
                                                mostAttendees![0].images[0],
                                            eventType:
                                                mostAttendees![0].eventType,
                                            title: mostAttendees![0].title,
                                            description:
                                                mostAttendees![0].description,
                                            dateTime: DateFormat(
                                                    'E, d MMM yyyy HH:mm')
                                                .format(DateTime.parse(
                                                    mostAttendees![0]
                                                        .scheduleStart)))),
                                const SizedBox(height: 15),
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
                                            maxWidth: (MediaQuery.of(context)
                                                .size
                                                .width)),
                                        child: CustomEventCard(
                                            slug: mostInteresting![0].slug,
                                            bgColor: int.parse(
                                                mostInteresting![0].bgcolor),
                                            imageUrl: cloudFrontUri! +
                                                mostInteresting![0].images[0],
                                            eventType:
                                                mostInteresting![0].eventType,
                                            title: mostInteresting![0].title,
                                            description:
                                                mostInteresting![0].description,
                                            dateTime: DateFormat(
                                                    'E, d MMM yyyy HH:mm')
                                                .format(DateTime.parse(
                                                    mostInteresting![0]
                                                        .scheduleStart)))),
                              ],
                            ),
                          );
                        },
                        error: (_, __) => const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Notes Created',
                              style: TextStyle(
                                  fontSize: 23, color: Colors.black54),
                            )),
                        loading: () => Center(
                              child: SpinKitCircle(
                                size: 50.0,
                                color: Colors.grey[700],
                              ),
                            ))),
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
