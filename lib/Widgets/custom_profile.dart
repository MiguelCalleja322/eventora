// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomProfile extends ConsumerWidget {
  CustomProfile({
    Key? key,
    this.image,
    required this.name,
    required this.username,
    required this.followers,
    required this.followings,
    this.events,
    required this.role,
    required this.follow,
    required this.isFollowed,
    required this.page,
    this.navigate,
    this.isFollowHidden = false,
  }) : super(key: key);
  late bool? isFollowHidden;
  late String? image = '';
  late String? name = '';
  late String? username = '';
  late String? followers = '';
  late String? followings = '';
  late String? events = '';
  late String? role = '';
  late VoidCallback follow;
  late int? isFollowed = 0;
  late String page = '';
  late VoidCallback? navigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.grey[900],
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)))),
      onPressed: () {
        Navigator.pushNamed(context, '/otherProfile', arguments: {
          'username': username!,
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    page == 'otherProfile'
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                  onPressed: navigate,
                                  child: Icon(
                                    Icons.chevron_left_sharp,
                                    color: Colors.grey[700],
                                  )),
                            ),
                          )
                        : const SizedBox(),
                    isFollowHidden == false
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: follow,
                                child: Text(
                                  isFollowed! == 1 ? 'Unfollow' : 'Follow',
                                  style: const TextStyle(
                                      color: Color(0xff525b6f),
                                      letterSpacing: 1.0,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image ??
                        'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826'),
                    radius: 50.0,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  name!,
                  style: const TextStyle(
                    color: Color(0xff525b6f),
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
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
                                color: Color(0xff525b6f),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            followers!,
                            style: const TextStyle(
                                color: Color(0xff525b6f),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w700),
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
                                color: Color(0xff525b6f),
                                letterSpacing: 1.0,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            followings!,
                            style: const TextStyle(
                                color: Color(0xff525b6f),
                                letterSpacing: 1.0,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w700),
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
                                      color: Color(0xff525b6f),
                                      letterSpacing: 1.0,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  events!,
                                  style: const TextStyle(
                                      color: Color(0xff525b6f),
                                      letterSpacing: 1.0,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w700),
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
            )
          ],
        ),
      ),
    );
  }
}
