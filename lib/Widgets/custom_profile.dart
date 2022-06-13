import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  CustomProfile({
    Key? key,
    this.image,
    this.name,
    this.followers,
    this.followings,
    this.events,
  }) : super(key: key);
  late String? image = '';
  late String? name = '';
  late String? followers = '';
  late String? followings = '';
  late String? events = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400.0,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => null,
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                            color: Color(0xFF114F5A),
                            letterSpacing: 1.0,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: CircleAvatar(
                  //     backgroundImage: NetworkImage(image!),
                  //     radius: 90.0,
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  Text(
                    name!,
                    style: const TextStyle(
                        color: Color(0xFF114F5A),
                        letterSpacing: 2.0,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          const Text(
                            'Followers',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            followers!,
                            style: const TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Following',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            followings!,
                            style: const TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'No. Events',
                            style: TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            events!,
                            style: const TextStyle(
                                color: Color(0xFF114F5A),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
