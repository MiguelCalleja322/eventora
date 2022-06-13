import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  CustomProfile({
    Key? key,
    this.image,
    required this.name,
    required this.followers,
    required this.followings,
    this.events,
    required this.role,
  }) : super(key: key);
  late String? image = '';
  late String? name = '';
  late String? followers = '';
  late String? followings = '';
  late String? events = '';
  late String? role = '';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    role == 'organizer'
                        ? Column(
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
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
