import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class SharedEventsPage extends StatefulWidget {
  const SharedEventsPage({Key? key, required this.sharedEvents}) : super(key: key);
  final List<dynamic>? sharedEvents;
  @override
  State<SharedEventsPage> createState() => _SharedEventsPageState();
}

class _SharedEventsPageState extends State<SharedEventsPage> {
  late String? cloudFrontUri = '';
  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  @override
  void initState() {
    fetchCloudFrontUri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shared Events',
                        style: TextStyle(
                            color: Colors.grey[800],
                            letterSpacing: 2.0,
                            fontSize: 30.0),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 0, color: Colors.transparent),
                                primary: Colors.grey[700],
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)))),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: const Icon(
                              Icons.chevron_left,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: Divider(
                    color: Colors.grey[600],
                  ),
                ),
                cloudFrontUri!.isEmpty || widget.sharedEvents!.isEmpty
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
                                'No Events Shared',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.sharedEvents!.length,
                        itemBuilder: (context, index) {
                          return CustomEventCard(
                              slug: widget.sharedEvents![index]['event']
                                  ['slug'],
                              bgColor: int.parse(widget.sharedEvents![index]
                                  ['event']['bgcolor']),
                              imageUrl: cloudFrontUri! +
                                  widget.sharedEvents![index]['event']['images']
                                      [0],
                              eventType: widget.sharedEvents![index]['event']
                                  ['event_type'],
                              title: widget.sharedEvents![index]['event']
                                  ['title'],
                              description: widget.sharedEvents![index]['event']
                                  ['description'],
                              dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                  .format(DateTime.parse(
                                      widget.sharedEvents![index]['event']
                                          ['schedule_start'])));
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
