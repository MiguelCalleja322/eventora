import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/Widgets/custom_profile.dart';
import 'package:eventora/controllers/user_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
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
  late Map<String, dynamic>? userProfile = {};
  late String? message = '';
  late String? cloudFrontUri = '';
  late String? model = 'save_event';
  late String role = '';
  late AutoDisposeFutureProvider userProvider;
  late bool loading = false;

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
    final user = ref.watch(userProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(userProvider),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: user.when(
                data: (user) {
                  print(user.events[0].name);
                },
                error: (_, __) => const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Notifications',
                      style: TextStyle(fontSize: 23, color: Colors.black54),
                    )),
                loading: () => Center(
                      child: SpinKitCircle(
                        size: 50.0,
                        color: Colors.grey[700],
                      ),
                    )),
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
