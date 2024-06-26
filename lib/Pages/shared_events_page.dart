import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_event_card_new.dart';
import 'package:eventora/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class SharedEventsPage extends StatefulWidget {
  const SharedEventsPage({Key? key, required this.sharedEvents})
      : super(key: key);
  final List<dynamic>? sharedEvents;
  @override
  State<SharedEventsPage> createState() => _SharedEventsPageState();
}

class _SharedEventsPageState extends State<SharedEventsPage> {
  late String? cloudFrontUri = '';
  late bool? loading = false;
  late String role = '';

  void getRole() async {
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!) ?? '';
  }

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
    getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Shared Events',
      ),
      body: SafeArea(
        child: loading! == true
            ? Center(
                child: SpinKitCircle(
                  size: 50.0,
                  color: Colors.grey[700],
                ),
              )
            : cloudFrontUri!.isEmpty || widget.sharedEvents!.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Events Shared',
                      style: TextStyle(fontSize: 23, color: Colors.black54),
                    ))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(
                            color: Colors.grey[600],
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.sharedEvents!.length,
                              itemBuilder: (context, index) {
                                return CustomEventCard(
                                    role: role,
                                    slug: widget.sharedEvents![index]['event']
                                        ['slug'],
                                    bgColor: int.parse(
                                        widget.sharedEvents![index]['event']
                                            ['bgcolor']),
                                    imageUrl: cloudFrontUri! +
                                        widget.sharedEvents![index]['event']
                                            ['images'][0],
                                    eventType: widget.sharedEvents![index]
                                        ['event']['event_type'],
                                    title: widget.sharedEvents![index]['event']
                                        ['title'],
                                    description: widget.sharedEvents![index]
                                        ['event']['description'],
                                    dateTime: DateFormat('E, d MMM yyyy HH:mm')
                                        .format(
                                            DateTime.parse(widget.sharedEvents![index]['event']['schedule_start'])));
                              }),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
