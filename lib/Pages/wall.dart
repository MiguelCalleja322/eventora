import 'package:eventora/Widgets/custom_event_category.dart';
import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WallPage extends StatefulWidget {
  const WallPage({Key? key}) : super(key: key);

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: eventCategories!.isEmpty
                ? Center(
                    child: SpinKitCircle(
                      size: 50.0,
                      color: Colors.grey[700],
                    ),
                  )
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Event Category',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 40.0)),
                      ),
                      SizedBox(
                        height: 40,
                        child: Divider(
                          color: Colors.grey[600],
                        ),
                      ),
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
                            return CustomEventCategory(
                              type: eventCategories![index]['type'],
                            );
                          }),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
