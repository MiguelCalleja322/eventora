import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Widgets/custom_events_card.dart';

class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({Key? key}) : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  late Map<String, dynamic>? user = {};
  late Map<String, dynamic>? userProfile = {};
  late String? cloudFrontUri = '';
  late String? model = 'save_event';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  Future<void> fetchUser(String username) async {
    user = await UserController().show(username);
    setState(() {
      userProfile = user!['user'] ?? {};
    });
  }

  @override
  void initState() {
    fetchUser('testtest123');
    fetchCloudFrontUri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: userProfile!.isEmpty
              ? SizedBox(
                  height: (MediaQuery.of(context).size.height),
                  width: (MediaQuery.of(context).size.width),
                  child: Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(
                      size: 50.0,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 380,
                        child: CustomProfile(
                            isFollowed: userProfile!['followers'] == null
                                ? 0
                                : userProfile!['followers'][0]['is_followed'],
                            follow: () {},
                            image: userProfile!['avatar'] != null
                                ? '$cloudFrontUri${userProfile!['avatar']}'
                                : null,
                            name: userProfile!['name'] ?? '',
                            followers:
                                userProfile!['followers_count'].toString(),
                            followings:
                                userProfile!['following_count'].toString(),
                            role: 'user'),
                      ),
                      Divider(
                        height: 10,
                        color: Colors.grey[700],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          userProfile!['role']['type'] == 'organizer'
                              ? Expanded(
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          model = 'events';
                                        });
                                      },
                                      child: Column(
                                        children: const [
                                          Icon(Icons.event),
                                          Text('Events'),
                                        ],
                                      )),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    model = 'share_event';
                                  });
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.calendar_month_outlined),
                                    Text('Shared Events')
                                  ],
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    setState(() {
                                      model = 'save_event';
                                    });
                                  });
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.note_add_outlined),
                                    Text('Saved Events')
                                  ],
                                )),
                          ),
                        ],
                      ),
                      userProfile![model].length != 0 ||
                              userProfile!['share_event'].length != 0 ||
                              userProfile!['events'].length != 0
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userProfile![model].length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                    height: 700,
                                    child: CustomEventCard(
                                      title: userProfile![model][index]['event']
                                          ['title'],
                                      description: userProfile![model][index]
                                          ['event']['description'],
                                      schedule: userProfile![model][index]
                                          ['event']['schedule'],
                                      images: userProfile![model][index]
                                          ['event']['images'],
                                      fees: userProfile![model][index]['event']
                                              ['fees']
                                          .toString(),
                                      likes: userProfile![model][index]['event']
                                              ['event_likes_count']
                                          .toString(),
                                      interested: userProfile![model][index]
                                              ['event']['interests_count']
                                          .toString(),
                                      attendees: userProfile![model][index]
                                              ['event']['attendees_count']
                                          .toString(),
                                      organizer: userProfile![model][index]
                                          ['event']['user']['name'],
                                      onPressedAttend: onPressedAttend,
                                      onPressedInterested: onPressedInterested,
                                      onPressedSave: onPressedSave,
                                    ));
                              })
                          : SizedBox(
                              width: (MediaQuery.of(context).size.width),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  userProfile!['save_event'].length == 0
                                      ? 'There are no saved events'
                                      : userProfile!['share_event'].length == 0
                                          ? 'There are no shared events'
                                          : 'There are no events',
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void onPressedAttend() {}
  void onPressedInterested() {}
  void onPressedSave() {}
}
