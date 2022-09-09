import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../controllers/events_controller.dart';
import '../models/user.dart';

// ignore: must_be_immutable
class OtherProfilePage extends ConsumerStatefulWidget {
  OtherProfilePage({Key? key, required this.username}) : super(key: key);
  late String? username;
  @override
  OtherProfilePageState createState() => OtherProfilePageState();
}

class OtherProfilePageState extends ConsumerState<OtherProfilePage> {
  late Map<String, dynamic>? user = {};
  late List<dynamic>? userEvents = [];
  late String? message = '';
  late String? cloudFrontUri = '';
  late String? model = 'save_event';
  late String role = '';
  late AutoDisposeFutureProvider userProvider;
  late bool loading = false;
  late int isFollowed = 0;

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
    setState(() {
      loading = true;
    });

    userProvider = FutureProvider.autoDispose<User?>((ref) {
      return UserController.show(widget.username!);
    });

    setState(() {
      loading = false;
    });
    // user = await UserController.show(username!);
    // setState(() {
    //   userProfile = user!['user'] ?? {};
    // });
  }

  @override
  void initState() {
    fetchUser(widget.username!);
    fetchCloudFrontUri();
    getRole();

    super.initState();
  }

  @override
  void dispose() {
    user = {};
    message = '';
    cloudFrontUri = '';
    model = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(userProvider),
          child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    user.when(
                        data: (user) {
                          userEvents = user.events.events;
                          return CustomProfile(
                              isFollowed: isFollowed,
                              eventsCount: user.eventsCount,
                              image: user.avatar != null
                                  ? '$cloudFrontUri${user.avatar}'
                                  : 'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826',
                              follow: () => follow(user.username),
                              name: user.name,
                              username: user.username,
                              followersCount: user.followersCount,
                              followingsCount: user.followingCount,
                              isBackButtonHidden: false,
                              isNavigateDisabled: true,
                              role: 'organizer');
                        },
                        error: (_, __) => const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Notifications',
                              style: TextStyle(
                                  fontSize: 23, color: Colors.black54),
                            )),
                        loading: () => Center(
                              child: SpinKitCircle(
                                size: 50.0,
                                color: Colors.grey[700],
                              ),
                            )),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Events',
                            style: TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: Divider(
                            color: Colors.grey[600],
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userEvents!.length,
                        itemBuilder: (context, index) {
                          return CustomEventCard(
                              slug: userEvents![index].slug,
                              bgColor: int.parse(userEvents![index].bgcolor),
                              imageUrl:
                                  cloudFrontUri! + userEvents![index].images[0],
                              eventType: userEvents![index].eventType,
                              title: userEvents![index].title,
                              description: userEvents![index].description,
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      userEvents![index].scheduleStart)));
                        }),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void follow(String username) async {
    Map<String, String> followUser = {
      'username': username,
    };

    isFollowed = await UserController.follow(followUser);
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
