// ignore_for_file: unnecessary_const, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../Widgets/custom_event_card_new.dart';
import '../controllers/auth_controller.dart';
import 'package:path/path.dart' as path;
import '../controllers/events_controller.dart';
import '../models/user.dart';
import '../utils/secure_storage.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

final profileProvider = FutureProvider.autoDispose((ref) async {
  final response = await AuthController().getProfile() ?? {};
  return await response;
});

class ProfilePageState extends ConsumerState<ProfilePage> {
  final ImagePicker imagePicker = ImagePicker();
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late bool loading = false;
  late String? newProfilePic = '';
  late String? cloudFrontUri = '';

  late String? role = '';
  late List<dynamic> events = [];

  void getRole() async {
    String? userDetailsMap =
        await StorageSevice().read(StorageSevice.userInfoKey);
    final Map<String, dynamic> userDetails = jsonDecode(userDetailsMap!);
    print(userDetails);
    role = userDetails['role'];
  }

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  @override
  void initState() {
    getRole();
    fetchCloudFrontUri();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    print(role);
    return profile.when(
        data: (profileData) {
          events = role == 'organizer'
              ? profileData['user']['events']
              : profileData['user']['user_events'];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            drawer: Drawer(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Events',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                          role == 'organizer'
                              ? Navigator.pushNamed(context, '/create_events')
                              : Navigator.pushNamed(
                                  context, '/create_user_event');
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.create_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Create an Event',
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
                              context, '/shared_events', arguments: {
                            'sharedEvents': profileData['user']['share_event']
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.share_outline,
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
                                'savedEvents': profileData['user']['save_event']
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
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Others',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                            '/create_appointment',
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.calendar_number_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Create Appointments',
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
                            '/create_task',
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.list_outline,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Create Tasks',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async => ref.refresh(profileProvider),
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
                            cloudFrontUri != '' || cloudFrontUri != null
                                ? CircleAvatar(
                                    backgroundImage: profileData['user']
                                                    ['avatar'] ==
                                                null ||
                                            profileData['user']['avatar'] == ''
                                        ? const NetworkImage(
                                            'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826')
                                        : NetworkImage(
                                            '$cloudFrontUri${profileData['user']['avatar']}'),
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
                                    onPressed: () async {
                                      await openImages();

                                      setState(() {
                                        profileData['user']['avatar'] =
                                            newProfilePic;
                                      });
                                    })),
                          ]),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          profileData['user']['name'],
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
                                  profileData['user']['followers_count']
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
                                  profileData['user']['following_count']
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
                                  profileData['user']['events_count']
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
                        SizedBox(
                          height: 20,
                          child: Divider(
                            color: Colors.grey[600],
                          ),
                        ),
                        events.isNotEmpty
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  return role == 'organizer'
                                      ? CustomEventCard(
                                          role: role!,
                                          model: profileProvider,
                                          isOptionsButton: true,
                                          slug: events[index]!['slug'],
                                          bgColor: int.parse(profileData['user']
                                              ['events'][index]!['bgcolor']),
                                          imageUrl: cloudFrontUri! +
                                              events[index]!['images'][0],
                                          eventType: profileData['user']
                                              ['events'][index]!['event_type'],
                                          title: events[index]!['title'],
                                          description: profileData['user']
                                              ['events'][index]!['description'],
                                          dateTime: DateFormat(
                                                  'E, d MMM yyyy HH:mm')
                                              .format(DateTime.parse(
                                                  events[index]!['schedule_start'])),
                                          scheduleStart: DateTime.parse(events[index]!['schedule_start']),
                                          scheduleEnd: DateTime.parse(events[index]!['schedule_end']))
                                      : CustomEventCard(slug: events[index]!['slug'], role: role!, model: profileProvider, imageUrl: cloudFrontUri! + events[index]!['images'][0], title: events[index]!['title'], description: events[index]!['description'], dateTime: DateFormat('E, d MMM yyyy HH:mm').format(DateTime.parse(events[index]!['schedule_start'])), scheduleStart: DateTime.parse(events[index]!['schedule_start']), scheduleEnd: DateTime.parse(events[index]!['schedule_end']));
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
                                        ref.refresh(profileProvider);
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
        },
        error: (_, __) => const Align(
            alignment: Alignment.center,
            child: Text(
              'No Notes Created',
              style: TextStyle(fontSize: 23, color: Colors.black54),
            )),
        loading: () => Center(
              child: SpinKitCircle(
                size: 50.0,
                color: Colors.grey[700],
              ),
            ));
  }

  openImages() async {
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

        newProfilePic = 'avatars/$newFileName';
      }
    } catch (e) {
      return;
    }
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
      CustomFlutterToast.showOkayToast(response['events']);
    } else {
      CustomFlutterToast.showErrorToast('Something went wrong...');
    }
    return;
  }

  void onPressedInterested(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().interested(eventSlug);

    if (response['interested'].isNotEmpty) {
      CustomFlutterToast.showOkayToast(response['interested']);
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
      CustomFlutterToast.showErrorToast(response['message']);
    } else {
      CustomFlutterToast.showOkayToast(response['events']);
    }

    return;
  }

  void onPressedLike(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    await EventController().like(eventSlug);
  }
}
