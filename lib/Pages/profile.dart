// ignore_for_file: unnecessary_const, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:eventora/Widgets/custom_loading.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/custom_events_card.dart';
import '../controllers/auth_controller.dart';
import 'package:path/path.dart' as path;

import '../controllers/events_controller.dart';
import '../utils/secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic>? profile = {};
  final ImagePicker imagePicker = ImagePicker();
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late bool loading = false;
  late String? cloudFrontURI = '';
  late String? model = 'save_event';
  late String? message = '';
  late String? role = '';
  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontURI = dotenv.env['CLOUDFRONT_URI'];
  }

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

  Future<void> fetchProfile() async {
    setState(() {
      loading = true;
    });
    profile = await AuthController().getProfile();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    if (mounted) {
      getRole();
      fetchProfile();
      fetchCloudFrontUri();
    }
    super.initState();
  }

  @override
  void dispose() {
    model = '';
    loading = false;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    profile = {};
    cloudFrontURI = '';
    message = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const LoadingPage()
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () => fetchProfile(),
              child: SafeArea(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Stack(children: [
                            CircleAvatar(
                              backgroundImage: profile!['user']['avatar'] ==
                                      null
                                  ? const NetworkImage(
                                      'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826')
                                  : NetworkImage(
                                      '$cloudFrontURI${profile!['user']['avatar']}'),
                              radius: 90.0,
                            ),
                            Positioned(
                                right: -15,
                                top: 145,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.update_outlined,
                                      color: Colors.black.withOpacity(0.5),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      openImages();
                                    })),
                          ]),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          profile!['user']['name'],
                          style: const TextStyle(
                              color: Color(0xFF114F5A),
                              letterSpacing: 2.0,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: [
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['followers_count']
                                      .toString()
                                      .toString(),
                                  style: const TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Following',
                                  style: TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['following_count']
                                      .toString(),
                                  style: const TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'No. Events',
                                  style: TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['events_count']
                                      .toString()
                                      .toString(),
                                  style: const TextStyle(
                                      color: Color(0xFF114F5A),
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            profile!['user']['role']['type'] == 'organizer'
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
                        const SizedBox(height: 15.0),
                        profile!['user']['role']['type'] == 'organizer'
                            ? OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/create_events');
                                },
                                child: const Text('Create Event'))
                            : const SizedBox(),
                        const SizedBox(height: 15.0),
                        profile!['user'][model].length != 0 ||
                                profile!['user'][model].length != 0 ||
                                profile!['user'][model].length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: profile!['user'][model].length,
                                itemBuilder: (context, index) {
                                  return CustomEventCard(
                                    role: role,
                                    venue: model == 'events'
                                        ? '${profile!['user'][model][index]['venue']['unit_no']} ${profile!['user'][model][index]['venue']['street_no']} ${profile!['user'][model][index]['venue']['street_name']} ${profile!['user'][model][index]['venue']['country']} ${profile!['user'][model][index]['venue']['state']} ${profile!['user'][model][index]['venue']['city']} ${profile!['user'][model][index]['venue']['zipcode']}'
                                        : '${profile!['user'][model][index]['event']['venue']['unit_no']} ${profile!['user'][model][index]['event']['venue']['street_no']} ${profile!['user'][model][index]['event']['venue']['street_name']} ${profile!['user'][model][index]['event']['venue']['country']} ${profile!['user'][model][index]['event']['venue']['state']} ${profile!['user'][model][index]['event']['venue']['city']} ${profile!['user'][model][index]['event']['venue']['zipcode']} ',
                                    registrationLink: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['registration_link']
                                        : profile!['user'][model][index]
                                            ['event']['registration_link'],
                                    slug: model == 'events'
                                        ? profile!['user'][model][index]['slug']
                                        : profile!['user'][model][index]
                                            ['event']['slug'],
                                    eventType: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['event_type']
                                        : profile!['user'][model][index]
                                            ['event']['event_type'],
                                    title: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['title']
                                        : profile!['user'][model][index]
                                            ['event']['title'],
                                    description: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['description']
                                        : profile!['user'][model][index]
                                            ['event']['description'],
                                    schedule: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['schedule']
                                        : profile!['user'][model][index]
                                            ['event']['schedule'],
                                    images: model == 'events'
                                        ? profile!['user'][model][index]
                                            ['images']
                                        : profile!['user'][model][index]
                                            ['event']['images'],
                                    fees: model == 'events'
                                        ? profile!['user'][model][index]['fees']
                                            .toString()
                                        : profile!['user'][model][index]
                                                ['event']['fees']
                                            .toString(),
                                    likes: model == 'events'
                                        ? profile!['user'][model][index]
                                                ['event_likes_count']
                                            .toString()
                                        : profile!['user'][model][index]
                                                ['event']['event_likes_count']
                                            .toString(),
                                    interested: model == 'events'
                                        ? profile!['user'][model][index]
                                                ['interests_count']
                                            .toString()
                                        : profile!['user'][model][index]
                                                ['event']['interests_count']
                                            .toString(),
                                    attendees: model == 'events'
                                        ? profile!['user'][model][index]
                                                ['attendees_count']
                                            .toString()
                                        : profile!['user'][model][index]
                                                ['event']['attendees_count']
                                            .toString(),
                                    organizer: model == 'events'
                                        ? profile!['user'][model][index]['user']
                                            ['username']
                                        : profile!['user'][model][index]
                                            ['event']['user']['username'],
                                    onPressedLike: () => onPressedLike(model ==
                                            'events'
                                        ? profile!['user'][model][index]['slug']
                                        : profile!['user'][model][index]
                                            ['event']['slug']),
                                    onPressedShare: () => onPressedShareEvent(
                                        model == 'events'
                                            ? profile!['user'][model][index]
                                                ['slug']
                                            : profile!['user'][model][index]
                                                ['event']['slug']),
                                    onPressedInterested: () =>
                                        onPressedInterested(model == 'events'
                                            ? profile!['user'][model][index]
                                                ['slug']
                                            : profile!['user'][model][index]
                                                ['event']['slug']),
                                    onPressedSave: () => onPressedSave(model ==
                                            'events'
                                        ? profile!['user'][model][index]['slug']
                                        : profile!['user'][model][index]
                                            ['event']['slug']),
                                  );
                                })
                            : Column(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        profile!['user'][model].length == 0
                                            ? 'There are no saved/shared events'
                                            : 'There are no events',
                                        style: const TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  TextButton(
                                      onPressed: () {
                                        fetchProfile();
                                      },
                                      child: const Icon(Icons.refresh))
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      String fileExtension = '';
      final XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        fileExtension = path.extension(selectedImage.path);
        String newFileName =
            randomString() + '-' + timestamp.toString() + fileExtension;
        File image = File(selectedImage.path);

        await S3.uploadFile(newFileName, image, 'avatars');

        Map<String, dynamic> avatar = {'avatar': 'avatars/$newFileName'};

        await AuthController().userUpdate(avatar);

        setState(() {
          profile!['user']['avatar'] = 'avatars/$newFileName';
        });
      } else {
        setState(() {
          loading = false;
        });

        return;
      }
    } catch (e) {
      return;
    }

    setState(() {
      loading = false;
    });
  }

  static randomString() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
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
