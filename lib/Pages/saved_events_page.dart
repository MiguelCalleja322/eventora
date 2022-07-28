import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class SavedEvents extends StatefulWidget {
  const SavedEvents({Key? key, required this.savedEvents}) : super(key: key);
  final List<dynamic>? savedEvents;
  @override
  State<SavedEvents> createState() => _SavedEventsState();
}

class _SavedEventsState extends State<SavedEvents> {
  late String? cloudFrontUri = '';
  late bool? loading = false;
  void fetchCloudFrontUri() async {
    setState(() {
      loading = true;
    });

    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
    setState(() {
      loading = false;
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
      appBar: const CustomAppBar(
        title: 'Saved Events',
      ),
      body: SafeArea(
        child: loading! == true
            ? Center(
                child: SpinKitCircle(
                  size: 50.0,
                  color: Colors.grey[700],
                ),
              )
            : cloudFrontUri!.isEmpty || widget.savedEvents!.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Events Saved',
                      style: TextStyle(fontSize: 23, color: Colors.black54),
                    ))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.savedEvents!.length,
                              itemBuilder: (context, index) {
                                return CustomEventCard(
                                    slug: widget.savedEvents![index]['event']
                                        ['slug'],
                                    bgColor: int.parse(
                                        widget.savedEvents![index]['event']
                                            ['bgcolor']),
                                    imageUrl: cloudFrontUri! +
                                        widget.savedEvents![index]['event']
                                            ['images'][0],
                                    eventType: widget.savedEvents![index]
                                        ['event']['event_type'],
                                    title: widget.savedEvents![index]['event']
                                        ['title'],
                                    description: widget.savedEvents![index]
                                        ['event']['description'],
                                    dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                        .format(
                                            DateTime.parse(widget.savedEvents![index]['event']['schedule_start'])));
                              }),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
