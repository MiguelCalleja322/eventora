import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/events_controller.dart';

// ignore: must_be_immutable
class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({Key? key, required this.username}) : super(key: key);
  late String? username;
  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  late Map<String, dynamic>? user = {};
  late Map<String, dynamic>? userProfile = {};
  late String? message = '';
  late String? cloudFrontUri = '';
  late String? model = 'save_event';
  late String role = '';

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  Future<void> fetchUser(String? username) async {
    user = await UserController.show(username!);
    setState(() {
      userProfile = user!['user'] ?? {};
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchUser(widget.username!);
      fetchCloudFrontUri();
      getRole();
    }
    super.initState();
  }

  @override
  void dispose() {
    user = {};
    userProfile = {};
    message = '';
    cloudFrontUri = '';
    model = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => fetchUser(widget.username!),
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
                          child: CustomProfile(
                              navigate: () => Navigator.pop(context),
                              page: 'otherProfile',
                              isFollowed: userProfile!['followers'].isEmpty
                                  ? 0
                                  : userProfile!['followers'][0]['is_followed'],
                              follow: () {},
                              image: userProfile!['avatar'] != null
                                  ? '$cloudFrontUri${userProfile!['avatar']}'
                                  : null,
                              name: userProfile!['name'] ?? '',
                              username: userProfile!['username'] ?? '',
                              followers: userProfile!['followers_count'],
                              followings: userProfile!['following_count'],
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
                                        style: OutlinedButton.styleFrom(
                                            primary: Colors.grey[800],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onPressed: () {
                                          setState(() {
                                            model = 'events';
                                          });
                                        },
                                        child: Column(
                                          children: const [
                                            Icon(Ionicons
                                                .calendar_number_outline),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('Events'),
                                          ],
                                        )),
                                  )
                                : const SizedBox(),
                            Expanded(
                              child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    setState(() {
                                      model = 'share_event';
                                    });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Ionicons.checkbox_outline),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Shared Events')
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    setState(() {
                                      setState(() {
                                        model = 'save_event';
                                      });
                                    });
                                  },
                                  child: Column(
                                    children: const [
                                      Icon(Ionicons.bookmark_outline),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Saved Events')
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        userProfile![model].length != 0 ||
                                userProfile![model].length != 0 ||
                                userProfile![model].length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: userProfile![model].length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      child: CustomEventCard(
                                    role: role,
                                    slug: model == 'events'
                                        ? userProfile![model][index]['slug']
                                        : userProfile![model][index]['event']
                                            ['slug'],
                                    eventType: model == 'events'
                                        ? userProfile![model][index]
                                            ['event_type']
                                        : userProfile![model][index]['event']
                                            ['event_type'],
                                    title: model == 'events'
                                        ? userProfile![model][index]['title']
                                        : userProfile![model][index]['event']
                                            ['title'],
                                    description: model == 'events'
                                        ? userProfile![model][index]
                                            ['description']
                                        : userProfile![model][index]['event']
                                            ['description'],
                                    dateTime: model == 'events'
                                        ? userProfile![model][index]
                                            ['schedule_start']
                                        : userProfile![model][index]['event']
                                            ['schedule_start'],
                                    bgColor: model == 'events'
                                        ? int.parse(userProfile![model][index]
                                            ['bgcolor'])
                                        : int.parse(userProfile![model][index]
                                            ['event']['bgcolor']),
                                    imageUrl: model == 'events'
                                        ? '$cloudFrontUri${userProfile![model][index]['images'][0]}'
                                        : '$cloudFrontUri${userProfile![model][index]['event']['images'][0]}',
                                  ));
                                })
                            : SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    userProfile![model].length == 0
                                        ? 'There are no saved/shared events'
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
      ),
    );
  }

  void onPressedShareEvent(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};
    Map<String, dynamic> response =
        await EventController().shareEvent(eventSlug);

    if (response['events'].isNotEmpty) {
      CustomFlutterToast.showOkayToast(response['events']!);
    } else {
      CustomFlutterToast.showErrorToast('Something went wrong...');
    }

    return;
  }

  void onPressedInterested(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().interested(eventSlug);

    if (response['interested'] != null) {
      CustomFlutterToast.showOkayToast(response['interested']!);
    } else {
      CustomFlutterToast.showErrorToast('Something went wrong...');
    }
    return;
  }

  void onPressedSave(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().saveEvent(eventSlug);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']!);
    } else {
      CustomFlutterToast.showOkayToast(response['events']!);
    }
    return;
  }

  void onPressedLike(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    await EventController().like(eventSlug);
  }
}
