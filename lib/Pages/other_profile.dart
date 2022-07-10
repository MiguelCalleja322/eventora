import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/custom_events_card_old.dart';
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

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  Future<void> fetchUser(String? username) async {
    user = await UserController().show(username!);
    setState(() {
      userProfile = user!['user'] ?? {};
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchUser(widget.username!);
      fetchCloudFrontUri();
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
                              userId: userProfile!['id'],
                              roleId: userProfile!['role']['user_id'],
                              navigate: () => Navigator.pushReplacementNamed(
                                  context, '/home'),
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
                                userProfile![model].length != 0 ||
                                userProfile![model].length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: userProfile![model].length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      child: CustomEventCards(
                                    registrationLink: model == 'events'
                                        ? userProfile![model][index]
                                            ['registration_link']
                                        : userProfile![model][index]['event']
                                            ['registration_link'],
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
                                    schedule: model == 'events'
                                        ? userProfile![model][index]['schedule']
                                        : userProfile![model][index]['event']
                                            ['schedule'],
                                    images: model == 'events'
                                        ? userProfile![model][index]['images']
                                        : userProfile![model][index]['event']
                                            ['images'],
                                    fees: model == 'events'
                                        ? userProfile![model][index]['fees']
                                            .toString()
                                        : userProfile![model][index]['event']
                                                ['fees']
                                            .toString(),
                                    likes: model == 'events'
                                        ? userProfile![model][index]
                                                ['event_likes_count']
                                            .toString()
                                        : userProfile![model][index]['event']
                                                ['event_likes_count']
                                            .toString(),
                                    interested: model == 'events'
                                        ? userProfile![model][index]
                                                ['interests_count']
                                            .toString()
                                        : userProfile![model][index]['event']
                                                ['interests_count']
                                            .toString(),
                                    attendees: model == 'events'
                                        ? userProfile![model][index]
                                                ['attendees_count']
                                            .toString()
                                        : userProfile![model][index]['event']
                                                ['attendees_count']
                                            .toString(),
                                    organizer: model == 'events'
                                        ? userProfile![model][index]['user']
                                            ['name']
                                        : userProfile![model][index]['event']
                                            ['user']['name'],
                                    onPressedLike: () => onPressedLike(
                                        model == 'events'
                                            ? userProfile![model][index]['slug']
                                            : userProfile![model][index]
                                                ['event']['slug']),
                                    onPressedShare: () => onPressedShareEvent(
                                        model == 'events'
                                            ? userProfile![model][index]['slug']
                                            : userProfile![model][index]
                                                ['event']['slug']),
                                    onPressedInterested: () =>
                                        onPressedInterested(model == 'events'
                                            ? userProfile![model][index]['slug']
                                            : userProfile![model][index]
                                                ['event']['slug']),
                                    onPressedSave: () => onPressedSave(
                                        model == 'events'
                                            ? userProfile![model][index]['slug']
                                            : userProfile![model][index]
                                                ['event']['slug']),
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
