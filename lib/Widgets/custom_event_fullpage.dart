import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomEventFullPage extends StatefulWidget {
  const CustomEventFullPage({Key? key}) : super(key: key);
  // late List<dynamic>? images = [];
  // late String? title = '';
  // late String? eventType = '';
  // late String? likes = '';
  // late String? interested = '';
  // late String? attendees = '';
  // late String? description = '';
  // late String? scheduleStart = '';
  // late String? scheduleEnd = '';
  // late String? fees = '';
  // late String? registrationLink = '';
  // late List<dynamic>? features = [];
  // late String? username = '';
  // late String? name = '';
  // late String? avatar = '';
  // late String? email = '';
  // late String? website = '';
  // late String? venue = '';

  @override
  State<CustomEventFullPage> createState() => _CustomEventFullPageState();
}

class _CustomEventFullPageState extends State<CustomEventFullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width),
                    child: Image.network(
                        'https://pyxis.nymag.com/v1/imgs/7aa/21a/c1de2c521f1519c6933fcf0d08e0a26fef-27-spongebob-squarepants.rsquare.w700.jpg',
                        height: 400,
                        fit: BoxFit.cover) // event image,
                    ),
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 0, color: Colors.transparent),
                                    primary: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                                onPressed: () {},
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
                                        width: 0, color: Colors.transparent),
                                    primary: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
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
                          color: const Color.fromARGB(255, 0, 101, 203)
                              .withOpacity(0.7)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Qatar Travel Mart - QTM2020', // event Title
                                style: TextStyle(
                                    fontSize: 20.0,
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
                                label: Text('Ticketed', // eventType
                                    style: TextStyle(color: Colors.grey[700])),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                          onPressed: () {},
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                          onPressed: () {},
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
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const <Widget>[
                        Text(
                          '2900 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'likes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: const <Widget>[
                        Text(
                          '2900 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'interested',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: const <Widget>[
                        Text(
                          '2900 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'attendees',
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
                  children: const [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Description:',
                          style: TextStyle(fontSize: 20.0),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."), // description
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: const [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Schedule:',
                          style: TextStyle(fontSize: 20.0),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Thu, 16th Sep 2021 10:00am')), // schedule start
                    SizedBox(
                      height: 5,
                    ),
                    Align(
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
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text('Thu, 16th Sep 2021 10:00am')), // schedule end
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
                          'Features:',
                          style: TextStyle(fontSize: 20.0),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Icon(
                          Icons.car_rental,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                        Expanded(
                            child: Icon(
                          Icons.wifi,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                        Expanded(
                            child: Icon(
                          Icons.monetization_on,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                        Expanded(
                            child: Icon(
                          Icons.local_parking,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                        Expanded(
                            child: Icon(
                          Icons.alarm_add,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                        Expanded(
                            child: Icon(
                          Icons.train,
                          color: Colors.grey[700],
                        )), //features of event location from database, configure listiewbuilder for later
                      ],
                    )
                  ],
                ),
              ),
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
                        const SizedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/otp.png'),
                            radius: 30.0,
                          ),
                        ), // organizer iamge
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: const <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Organizer:',
                                    style: TextStyle(fontSize: 12.0),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Organizers Name',
                                    style: TextStyle(fontSize: 16.0),
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
                        const Expanded(
                            flex: 3,
                            child: Text(
                                'miguelcalleja1738@gmail.com') // email of organizer
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
                        const Expanded(
                            flex: 3,
                            child:
                                Text('www.google.com') // website of organizer
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
                          backgroundColor:
                              const Color.fromARGB(255, 248, 248, 248),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)))),
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Expanded(
                              flex: 3,
                              child: Text('Lipa City') // website of organizer
                              ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.location_searching_outlined,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          //ternary function here and function
        },
      ),
    );
  }
}
