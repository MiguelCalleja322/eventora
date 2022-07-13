import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Widgets/custom_appbar.dart';

class EventCategpry extends StatefulWidget {
  const EventCategpry({Key? key}) : super(key: key);

  @override
  State<EventCategpry> createState() => _EventCategpryState();
}

class _EventCategpryState extends State<EventCategpry> {
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? eventCategories = [];

  void getEventCategories() async {
    fetchedCategories = await EventCategoriesController().index();

    if (fetchedCategories!.isNotEmpty) {
      setState(() {
        eventCategories = fetchedCategories!['event_categories'] ?? [];
      });
    }
  }

  @override
  void initState() {
    getEventCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Event Category',
        height: 70,
        hideBackButton: true,
      ),
      body: eventCategories!.isEmpty
          ? Center(
              child: SpinKitCircle(
                size: 50.0,
                color: Colors.grey[700],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2.6 / 2.5,
                        ),
                        itemCount: eventCategories!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/wall_page',
                                      arguments: {
                                        'type': eventCategories![index]['type']
                                      });
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/event_categories/${eventCategories![index]['type']}.jpg',
                                      height: 110,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        eventCategories![index]['type'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
