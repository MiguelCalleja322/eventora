import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_notification_card.dart';
import 'package:eventora/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends ConsumerState<NotificationsPage> {
  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: '.env');
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  final notificationsProvider = FutureProvider.autoDispose((ref) {
    return NotificationsController.index();
  });

  @override
  void initState() {
    fetchCloudFrontUri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notifications',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async => ref.refresh(notificationsProvider),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        border:
                            Border.all(width: 0.0, style: BorderStyle.none)),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        child: notifications.when(
                            data: (notification) {
                              return const CustomNotificationCard();
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
                                ))))),
          ),
        ),
      ),
    );
  }
}
