import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class WallPage extends StatefulWidget {
  const WallPage({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? events = [];
  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
  }

  void getEventsFromCategory() async {
    fetchedCategories = await EventCategoriesController().show(widget.type);

    if (fetchedCategories!.isNotEmpty) {
      setState(() {
        events = fetchedCategories!['event_categories']['events'] ?? [];
      });
    }
  }

  @override
  void initState() {
    fetchCloudFrontUri();
    getEventsFromCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                events!.isEmpty
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 132, 132, 132),
                                width: 2.0,
                                style: BorderStyle.solid)),
                        child: SizedBox(
                          height: 150,
                          width: (MediaQuery.of(context).size.width),
                          child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'No Events Posted for this Category',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: events!.length,
                        itemBuilder: (context, index) {
                          return CustomEventCard(
                              slug: events![index]['slug'],
                              bgColor: int.parse(events![index]['bgcolor']),
                              imageUrl:
                                  cloudFrontUri! + events![index]['images'][0],
                              eventType: events![index]['event_type'],
                              title: events![index]['title'],
                              description: events![index]['description'],
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      events![index]['schedule_start'])));
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
