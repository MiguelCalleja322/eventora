// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

// ignore: must_be_immutable
class CustomEventCard extends StatelessWidget {
  CustomEventCard({
    Key? key,
    required this.title,
    required this.description,
    required this.schedule,
    required this.fees,
    required this.likes,
    required this.interested,
    required this.attendees,
    required this.organizer,
    required this.onPressedShare,
    required this.onPressedInterested,
    required this.onPressedSave,
    required this.onPressedLike,
    required this.images,
    required this.eventType,
    this.registrationLink,
    this.venue,
  }) : super(key: key);

  late String? title = '';
  late String? description = '';
  late String? schedule = '';
  late String? fees = '';
  late String? likes = '';
  late String? interested = '';
  late String? attendees = '';
  late String? organizer = '';
  late String? eventType = '';
  late String? registrationLink = '';
  late String? venue = '';
  late List<dynamic>? images = [];
  final VoidCallback onPressedShare;
  final VoidCallback onPressedInterested;
  final VoidCallback onPressedSave;
  final VoidCallback onPressedLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 200,
            child: CarouselSlider.builder(
                itemCount: images!.length,
                itemBuilder: (context, index, realIndex) {
                  return BuildImage(images![index], index);
                },
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  viewportFraction: 2,
                  autoPlayInterval: const Duration(seconds: 5),
                )),
          ),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              title!,
              style: TextStyle(
                color: Colors.amber[800],
                letterSpacing: 2.0,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'Description:',
            style: TextStyle(
                color: Colors.grey[600], letterSpacing: 2.0, fontSize: 14.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            description!,
            style: TextStyle(
                color: Colors.grey[700],
                letterSpacing: 2.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade),
          ),
          const SizedBox(height: 15.0),
          Text(
            'Schedule:',
            style: TextStyle(
                color: Colors.grey[600], letterSpacing: 2.0, fontSize: 14.0),
          ),
          const SizedBox(width: 10.0),
          Text(
            schedule!,
            style: TextStyle(
              color: Colors.grey[700],
              letterSpacing: 2.0,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            eventType == 'ticketed' ? 'Fees:' : 'Registration Link:',
            style: TextStyle(
                color: Colors.grey[600], letterSpacing: 1.0, fontSize: 14.0),
          ),
          const SizedBox(width: 10.0),
          Text(
            eventType == 'ticketed' ? fees! : registrationLink!,
            style: TextStyle(
                color: Colors.grey[700],
                letterSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade),
          ),
          const SizedBox(height: 15.0),
          Text(
            'Venue:',
            style: TextStyle(
                color: Colors.grey[600], letterSpacing: 1.0, fontSize: 14.0),
          ),
          const SizedBox(width: 10.0),
          Text(
            venue != '' ? venue! : 'To be posted',
            style: TextStyle(
                color: Colors.grey[700],
                letterSpacing: 1.0,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.clip),
          ),
          const SizedBox(height: 15.0),
          organizer == ''
              ? const SizedBox()
              : Text(
                  'Organizer:',
                  style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 2.0,
                      fontSize: 14.0),
                ),
          organizer == ''
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/otherProfile',
                        arguments: {
                          'username': organizer!,
                        });
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    ),
                  ),
                  child: Text(
                    organizer!,
                    style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 30.0),
              interested == ''
                  ? const SizedBox()
                  : Column(
                      children: <Widget>[
                        Text(
                          'Interested',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 1.0,
                              fontSize: 14.0),
                        ),
                        Text(
                          interested!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 1.0,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(width: 30.0),
              attendees == ''
                  ? const SizedBox()
                  : Column(
                      children: <Widget>[
                        Text(
                          'Attendees',
                          style: TextStyle(
                              color: Colors.grey[600],
                              letterSpacing: 2.0,
                              fontSize: 14.0),
                        ),
                        Text(
                          attendees!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MaterialButton(
                    onPressed: onPressedLike,
                    textColor: Colors.white,
                    elevation: 0,
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.topEnd(top: -16, end: -16),
                          badgeContent: Text(likes!),
                          child: Icon(Icons.thumb_up_sharp,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Like',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12),
                        )
                      ],
                    )),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: onPressedShare,
                  textColor: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: onPressedInterested,
                  textColor: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Icon(
                        Icons.interests,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Attend',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: onPressedSave,
                  textColor: Colors.white,
                  elevation: 0,
                  child: Column(children: [
                    Icon(Icons.save_as_outlined, color: Colors.grey[700]),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    )
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget BuildImage(String networkImage, int index) => Container(
        color: Colors.grey[500],
        child: Image.network(
          'https://d2aobpa1aevk77.cloudfront.net/$networkImage',
          fit: BoxFit.cover,
        ),
      );
}
