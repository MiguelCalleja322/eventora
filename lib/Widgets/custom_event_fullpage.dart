import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomEventFullPage extends StatefulWidget {
  const CustomEventFullPage({
    Key? key,
    required this.slug,
  }) : super(key: key);

  final String? slug;

  @override
  State<CustomEventFullPage> createState() => _CustomEventFullPageState();
}

class _CustomEventFullPageState extends State<CustomEventFullPage> {
  late String? cloudFrontUri = '';
  late Map<String, dynamic>? eventMap = {};
  late Map<String, dynamic>? event = {};
  late String? message = '';
  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  Future<void> fetchEventUsingSlug() async {
    eventMap = await EventController().show(widget.slug!) ?? {};

    setState(() {
      event = eventMap!['event'] ?? {};
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchCloudFrontUri();
      fetchEventUsingSlug();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEventUsingSlug,
          child: SingleChildScrollView(
            child: event!.isEmpty
                ? Center(
                    child: SpinKitCircle(
                      size: 50.0,
                      color: Colors.grey[700],
                    ),
                  )
                : Column(
                    children: [
                      cloudFrontUri! == ''
                          ? const SizedBox(
                              height: 0,
                            )
                          : Stack(children: [
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: 400,
                                      maxWidth:
                                          (MediaQuery.of(context).size.width)),
                                  child: CarouselSlider.builder(
                                    itemCount:
                                        eventMap!['event']['images']!.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return Image.network(
                                          '$cloudFrontUri${event!['images'][index]}',
                                          fit: BoxFit.cover,
                                          width: (MediaQuery.of(context)
                                              .size
                                              .width),
                                          height: 400);
                                    },
                                    options: CarouselOptions(
                                      height: 400,
                                      autoPlay: false,
                                      viewportFraction: 1,
                                    ),
                                  )),
                              Positioned(
                                top: 0,
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      width: 0,
                                                      color: Colors
                                                          .transparent),
                                                  primary: Colors.white,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.0)))),
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(
                                                    context, '/home');
                                              },
                                              child: const Icon(
                                                Icons.chevron_left,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      width: 0,
                                                      color: Colors
                                                          .transparent),
                                                  primary: Colors.white,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.0)))),
                                              onPressed: () {},
                                              child: const Icon(
                                                Icons.share,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: SizedBox(
                                  height: 100,
                                  width: (MediaQuery.of(context).size.width),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color:
                                            Color(int.parse(event!['bgcolor']!))
                                                .withOpacity(0.7)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              // overflow: TextOverflow.ellipsis,
                                              event!['title'], // event Title
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Chip(
                                              padding: const EdgeInsets.all(5),
                                              backgroundColor: Colors.white,
                                              label: Text(
                                                  event![
                                                      'event_type'], // eventType
                                                  style: TextStyle(
                                                      color: Colors.grey[700])),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
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
                                    onPressedLike(widget.slug);
                                  },
                                  child: const Icon(
                                    FeatherIcons.heart,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
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
                                onPressed: () {},
                                child: const Icon(
                                  FeatherIcons.messageCircle,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
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
                                    onPressedSave(widget.slug!);
                                  },
                                  child: const Icon(
                                    Icons.bookmark_border_outlined,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                  event!['event_likes_count'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  ' likes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  event!['interests_count'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  ' interested',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  event!['attendees_count'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  ' attendees',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Description:',
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text(event!['description'])), // description
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  event!['fees'] != 0
                                      ? 'Fees:'
                                      : 'Registration Link:',
                                  style: const TextStyle(fontSize: 20.0),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(event!['fees'] != 0
                                  ? event!['fees']!.toString()
                                  : event!['registration_link']),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Schedule:',
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(event![
                                    'schedule_start'])), // schedule start
                            const SizedBox(
                              height: 5,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 45,
                                child: VerticalDivider(
                                  width: 1.0,
                                  thickness: 2.0,
                                  color: Color.fromARGB(255, 0, 99, 198),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    event!['schedule_end']!)), // schedule end
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 100,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(15),
                      //     child: Column(
                      //       children: [
                      //         const Align(
                      //             alignment: Alignment.centerLeft,
                      //             child: Text(
                      //               'Features:',
                      //               style: TextStyle(fontSize: 20.0),
                      //             )),
                      //         const SizedBox(
                      //           height: 15,
                      //         ),
                      //         ListView.builder(
                      //           itemCount: widget.eventFeatures!.length,
                      //           shrinkWrap: true,
                      //           scrollDirection: Axis.horizontal,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             if (widget.eventFeatures![index] == 'Taxi') {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.car_rental_outlined),
                      //               );
                      //             } else if (widget.eventFeatures![index] ==
                      //                 'Monetize') {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.paid_outlined),
                      //               );
                      //             } else if (widget.eventFeatures![index] == 'Wifi') {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.wifi),
                      //               );
                      //             } else if (widget.eventFeatures![index] == 'Train') {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.train_outlined),
                      //               );
                      //             } else if (widget.eventFeatures![index] ==
                      //                 'Good Sound') {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.spatial_audio),
                      //               );
                      //             } else {
                      //               return const Padding(
                      //                 padding: EdgeInsets.all(5.0),
                      //                 child: Icon(Icons.ac_unit),
                      //               );
                      //             }
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //contact information
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Contact Information:',
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                    height: 90,
                                    child: event!['user']['avatar'] == null ||
                                            event!['user']['avatar'] == ''
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                                fit: BoxFit.cover,
                                                'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826'),
                                          )
                                        : CircleAvatar(
                                            maxRadius: 30,
                                            backgroundImage: NetworkImage(
                                                '$cloudFrontUri${event!['user']['avatar']}'),
                                          )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Organizer:',
                                            style: TextStyle(fontSize: 14.0),
                                          )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            event!['user']['name'],
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Text(event!['user']
                                        ['email']) // email of organizer
                                    ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.web,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Text(event!['user']['website'] ??
                                        'No Website found') // website of organizer
                                    ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Location: ',
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.grey[900],
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)))),
                              onPressed: () {
                                showMap(event!['venue']['location'].toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 0,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Text(
                                            event!['venue']['full_address'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(event!['venue']['location']),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 0,
                                      child: Icon(
                                        Icons.location_searching_outlined,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: const Color(0xFFF7F8FB),
        selectedItemColor: Colors.grey[700],
        elevation: 8,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        unselectedItemColor: Colors.grey[800],
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Attend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Interested',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Decline',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.pushReplacementNamed(context, '/payment', arguments: {
              'title': event!['title'],
              'description': event!['description'],
              'fees': event!['fees'],
              'venue': event!['venue']['full_address'],
              'schedule':
                  '${event!['schedule_start']} - ${event!['schedule_end']} ',
              'slug': widget.slug,
            });
          } else if (value == 1) {
            onPressedInterested(widget.slug);
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
    );
  }

  void showMap(String coordinates) {
    final splitted = coordinates.split(',');
    final latitude = double.parse(splitted[0]);
    final longitude = double.parse(splitted[1]);

    Navigator.pushReplacementNamed(context, '/show_map', arguments: {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void onPressedInterested(String? slug) async {
    Color? toastColor = Colors.grey[700];
    Map<String, dynamic> eventSlug = {'slug': slug!};

    Map<String, dynamic> response =
        await EventController().interested(eventSlug);

    if (response['interested'] != null) {
      message = response['interested'];
      toastColor = Colors.grey[700];
    } else {
      message = 'Something went wrong...';
      toastColor = Colors.red[500];
    }

    Fluttertoast.showToast(
        msg: message!,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: toastColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
  }

  void onPressedSave(String? slug) async {
    Color? toastColor = Colors.grey[700];
    Map<String, dynamic> eventSlug = {'slug': slug!};
    String message = '';
    Map<String, dynamic> response =
        await EventController().saveEvent(eventSlug);

    if (response['message'] != null) {
      message = response['message'];
      toastColor = Colors.red[700];
    } else {
      message = response['events'];
      toastColor = Colors.grey[700];
    }

    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: toastColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);
    return;
  }

  void onPressedLike(String? slug) async {
    Map<String, dynamic> eventSlug = {'slug': slug!};

    await EventController().like(eventSlug) ?? 0;
  }
}
