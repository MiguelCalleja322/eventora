import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_notification_card.dart';
import 'package:eventora/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eventora/models/notification.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

final notificationsProvider = FutureProvider.autoDispose<Notifications?>((ref) {
  return NotificationsController.index();
});

class NotificationsPageState extends ConsumerState<NotificationsPage> {
  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: '.env');
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

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
                    child: notifications.when(
                        data: (notification) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: notification!.notifications?.length,
                              itemBuilder: (context, index) {
                                String? avatar = notification
                                    .notifications![index].user.avatar;
                                return CustomNotificationCard(
                                    id: notification.notifications![index].id,
                                    username: notification
                                        .notifications![index].user.username,
                                    name: notification
                                        .notifications![index].user.name,
                                    avatar: avatar != null
                                        ? '$cloudFrontUri$avatar'
                                        : '',
                                    eventSlug: notification
                                        .notifications![index].eventSlug,
                                    createdAt: DateFormat('E, d MMM yyyy HH:mm')
                                        .format(DateTime.parse(notification
                                            .notifications![index].createdAt)),
                                    label: notification
                                        .notifications![index].label,
                                    isRead: notification
                                        .notifications![index].isRead);
                              });
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
                            )))),
          ),
        ),
      ),
    );
  }
}
