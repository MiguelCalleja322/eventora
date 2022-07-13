// ignore_for_file: unnecessary_const, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../Widgets/custom_event_card_new.dart';
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
  late String? cloudFrontUri = '';
  late String? message = '';
  late String? role = '';

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

  Future<void> fetchProfile() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontURI = dotenv.env['CLOUDFRONT_URI'];
    });
    setState(() {
      loading = true;
    });
    profile = await AuthController().getProfile() ?? {};

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getRole();
    fetchCloudFrontUri();
    fetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    loading = false;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    profile = {};
    cloudFrontURI = '';
    message = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return profile!.isEmpty
        ? const LoadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            drawer: Drawer(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.grey[800],
                            letterSpacing: 2.0,
                            fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Divider(
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.grey[900],
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/shared_events',
                              arguments: {
                                'sharedEvents': profile!['user']['share_event']
                              });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.calendar_number_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Shared Events',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.grey[900],
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/saved_events',
                              arguments: {
                                'savedEvents': profile!['user']['save_event']
                              });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.bookmark_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Saved Events',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.grey[900],
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/list_notes',
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.document_text_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Create Notes',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
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
                            cloudFrontURI != '' || cloudFrontURI != null
                                ? CircleAvatar(
                                    backgroundImage: profile!['user']
                                                    ['avatar'] ==
                                                null ||
                                            profile!['user']['avatar'] == ''
                                        ? const NetworkImage(
                                            'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826')
                                        : NetworkImage(
                                            '$cloudFrontURI${profile!['user']['avatar']}'),
                                    radius: 90.0,
                                  )
                                : const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826'),
                                    radius: 90.0,
                                  ),
                            Positioned(
                                right: -15,
                                top: 145,
                                child: IconButton(
                                    icon: Icon(
                                      Ionicons.camera_outline,
                                      color: Colors.grey[800],
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
                          style: TextStyle(
                              color: Colors.grey[800],
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
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['followers_count']
                                      .toString()
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['following_count']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'No. Events',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  profile!['user']['events_count']
                                      .toString()
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const SizedBox(height: 15.0),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                primary: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/create_events');
                            },
                            child: const Text('Create Event')),
                        const SizedBox(height: 15.0),
                        profile!['user']['events'].length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: profile!['user']['events'].length,
                                itemBuilder: (context, index) {
                                  return CustomEventCard(
                                      slug: profile!['user']['events']
                                          [index]!['slug'],
                                      bgColor: int.parse(profile!['user']
                                          ['events'][index]!['bgcolor']),
                                      imageUrl: cloudFrontUri! +
                                          profile!['user']['events']
                                              [index]!['images'][0],
                                      eventType: profile!['user']['events']
                                          [index]!['event_type'],
                                      title: profile!['user']['events']
                                          [index]!['title'],
                                      description: profile!['user']['events']
                                          [index]!['description'],
                                      dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                          .format(DateTime.parse(
                                              profile!['user']['events'][index]!['schedule_start'])));
                                })
                            : Column(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width),
                                    child: const Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        'There are no events',
                                        style: const TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  TextButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.grey[700],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        fetchProfile();
                                      },
                                      child: const Icon(Ionicons.refresh))
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
            randomString() + timestamp.toString() + fileExtension;
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
        10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
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
