import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/controllers/user_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserEventFullPage extends ConsumerStatefulWidget {
  const UserEventFullPage({Key? key, this.slug}) : super(key: key);
  final String? slug;
  @override
  UserEventFullPageState createState() => UserEventFullPageState();
}

class UserEventFullPageState extends ConsumerState<UserEventFullPage> {
  late String? cloudFrontUri = '';
  late Map<String, dynamic>? event = {};
  late AutoDisposeFutureProvider eventProvider;

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  void generateEventProvider() {
    eventProvider = FutureProvider.autoDispose((ref) {
      return UserEventController.show(widget.slug!);
    });
  }

  @override
  void initState() {
    fetchCloudFrontUri();
    generateEventProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventData = ref.watch(eventProvider);
    return Scaffold(
      body: eventData.when(
          data: (data) {
            event = data['user_event'];
            return SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(eventProvider),
                  child: event!.isEmpty
                      ? Center(
                          child: SpinKitCircle(
                            size: 50.0,
                            color: Colors.grey[700],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              cloudFrontUri! == ''
                                  ? const SizedBox.shrink()
                                  : Stack(
                                      children: [
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: 400,
                                                maxWidth:
                                                    (MediaQuery.of(context)
                                                        .size
                                                        .width)),
                                            child: CarouselSlider.builder(
                                              itemCount:
                                                  event!['images']!.length,
                                              itemBuilder:
                                                  (context, index, realIndex) {
                                                return CachedNetworkImage(
                                                    imageUrl:
                                                        '$cloudFrontUri${event!['images'][index]}',
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    width:
                                                        (MediaQuery.of(context)
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
                                            width: (MediaQuery.of(context)
                                                .size
                                                .width),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SizedBox(
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                            side: const BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent),
                                                            primary:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: SizedBox(
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                            side: const BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent),
                                                            primary:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                            width: (MediaQuery.of(context)
                                                .size
                                                .width),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 0, 106, 94)
                                                      .withOpacity(0.7)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        // overflow: TextOverflow.ellipsis,
                                                        event![
                                                            'title'], // event Title
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
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
                                        child: Text(event![
                                            'description'])), // description
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
                                          color:
                                              Color.fromARGB(255, 0, 99, 198),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(event![
                                            'schedule_end']!)), // schedule end
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
                                            child: event!['user']['avatar'] ==
                                                        null ||
                                                    event!['user']['avatar'] ==
                                                        ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Name:',
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    event!['user']['name'],
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
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
                                        showMap(event!['venue']['location']
                                            .toString());
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
                                                    event!['venue']
                                                        ['full_address'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(event!['venue']
                                                      ['location']),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 0,
                                              child: Icon(
                                                Icons
                                                    .location_searching_outlined,
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
                        )),
            );
          },
          error: (_, __) => const Align(
              alignment: Alignment.center,
              child: Text(
                'No Notes Created',
                style: TextStyle(fontSize: 23, color: Colors.black54),
              )),
          loading: () => Center(
                child: SpinKitCircle(
                  size: 50.0,
                  color: Colors.grey[700],
                ),
              )),
    );
  }

  void showMap(String coordinates) {
    final splitted = coordinates.split(',');
    final latitude = double.parse(splitted[0]);
    final longitude = double.parse(splitted[1]);

    Navigator.pushNamed(context, '/show_map', arguments: {
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
