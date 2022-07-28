import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/controllers/feature_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

final feedProvider = FutureProvider.autoDispose((ref) {
  return FeaturePageController.feed();
});

class FeedPageState extends ConsumerState<FeedPage> {
  late String? cloudFrontUri = '';
  late List<dynamic>? events = [];

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  @override
  void initState() {
    fetchCloudFrontUri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Feed',
        height: 135,
        hideSearchBar: false,
        hideBackButton: true,
      ),
      body: SafeArea(
        child: cloudFrontUri! == ''
            ? Center(
                child: SpinKitCircle(
                  size: 50.0,
                  color: Colors.grey[700],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(feedProvider),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: feeds.when(
                        data: (feed) {
                          feed['feed'].isEmpty
                              ? events = []
                              : events = feed['feed'];

                          return events!.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'No new Feeds',
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.black54),
                                        )),
                                    const SizedBox(height: 10),
                                    IconButton(
                                      onPressed: () async =>
                                          ref.refresh(feedProvider),
                                      icon: const Icon(
                                          Ionicons.refresh_circle_outline),
                                      color: Colors.black54,
                                    )
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: events!.length,
                                          itemBuilder: (context, index) {
                                            return CustomEventCard(
                                                slug: events![index]['slug'],
                                                bgColor: int.parse(
                                                    events![index]['bgcolor']),
                                                imageUrl:
                                                    '$cloudFrontUri${events![index]['images'][0]}',
                                                eventType: events![index]
                                                    ['event_type'],
                                                title: events![index]['title'],
                                                description: events![index]
                                                    ['description'],
                                                dateTime: DateFormat(
                                                        'E, d MMM yyyy HH:mm')
                                                    .format(DateTime.parse(
                                                        events![index][
                                                            'schedule_start'])));
                                          })
                                    ],
                                  ),
                                );
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
                            ))),
              ),
      ),
    );
  }
}
