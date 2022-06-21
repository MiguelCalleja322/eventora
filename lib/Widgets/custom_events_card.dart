import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    required this.onPressedAttend,
    required this.onPressedInterested,
    required this.onPressedSave,
    required this.images,
  }) : super(key: key);

  late String? title = '';
  late String? description = '';
  late String? schedule = '';
  late String? fees = '';
  late String? likes = '';
  late String? interested = '';
  late String? attendees = '';
  late String? organizer = '';
  late List<dynamic>? images = [];
  final VoidCallback onPressedAttend;
  final VoidCallback onPressedInterested;
  final VoidCallback onPressedSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
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
            const SizedBox(height: 30.0),
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
            const SizedBox(height: 30.0),
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
            Row(
              children: [
                Text(
                  'fees:',
                  style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 2.0,
                      fontSize: 14.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  fees!,
                  style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                likes == ''
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Text(
                            'Likes',
                            style: TextStyle(
                                color: Colors.grey[600],
                                letterSpacing: 2.0,
                                fontSize: 14.0),
                          ),
                          Text(
                            likes!,
                            style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 2.0,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(width: 30.0),
                interested == ''
                    ? const SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Interested',
                            style: TextStyle(
                                color: Colors.grey[600],
                                letterSpacing: 2.0,
                                fontSize: 14.0),
                          ),
                          Text(
                            interested!,
                            style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 2.0,
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 30.0),
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
                : Text(
                    organizer!,
                    style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () => onPressedAttend,
                  color: Colors.green,
                  textColor: Colors.white,
                  elevation: 0,
                  child: const Text('Attend'),
                ),
                MaterialButton(
                  onPressed: () => onPressedInterested,
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 0,
                  child: const Text('Interested'),
                ),
                MaterialButton(
                  onPressed: () => onPressedSave,
                  color: Colors.amber[800],
                  textColor: Colors.white,
                  elevation: 0,
                  child: const Text('Save'),
                )
              ],
            )
          ],
        ),
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
