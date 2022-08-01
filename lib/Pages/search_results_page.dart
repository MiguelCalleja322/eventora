import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  const SearchResultPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends ConsumerState<SearchResultPage> {
  late AutoDisposeFutureProvider eventProvider;

  late String? cloudFrontUri = '';
  late List<dynamic>? events = [];
  late String role = '';

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

  void generateEventProvider() {
    eventProvider = FutureProvider.autoDispose((ref) {
      return EventController.search(widget.title!);
    });
  }

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  @override
  void initState() {
    getRole();
    fetchCloudFrontUri();
    generateEventProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(eventProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Results',
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
                onRefresh: () async => ref.refresh(eventProvider),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: results.when(
                        data: (result) {
                          result['events'].isEmpty
                              ? events = []
                              : events = result['events'];

                          return events!.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Search Result Empty',
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.black54),
                                        )),
                                    const SizedBox(height: 10),
                                    IconButton(
                                      onPressed: () async =>
                                          ref.refresh(eventProvider),
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
                                                role: role,
                                                eventCategory: events![index]
                                                    ['event_category']['type'],
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
