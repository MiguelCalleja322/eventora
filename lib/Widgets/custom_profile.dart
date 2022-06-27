import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  CustomProfile(
      {Key? key,
      this.image,
      required this.name,
      required this.followers,
      required this.followings,
      this.events,
      required this.role,
      required this.follow,
      required this.isFollowed})
      : super(key: key);
  late String? image = '';
  late String? name = '';
  late String? followers = '';
  late String? followings = '';
  late String? events = '';
  late String? role = '';
  late VoidCallback follow;
  late int? isFollowed = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: follow,
                    child: Text(
                      isFollowed! == 1 ? 'Unfollow' : 'Follow',
                      style: const TextStyle(
                          color: Color(0xFF114F5A),
                          letterSpacing: 1.0,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image ??
                        'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826'),
                    radius: 90.0,
                  ),
                ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
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
                    ),
                    Expanded(
                      child: Column(
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
                    ),
                    role == 'organizer'
                        ? Expanded(
                            child: Column(
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
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          )
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
