// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

class CustomProfile extends ConsumerWidget {
  CustomProfile({
    Key? key,
    this.image,
    this.name,
    this.username,
    this.followersCount,
    this.followingsCount,
    this.eventsCount,
    this.role,
    this.isBackButtonHidden = true,
    this.isNavigateDisabled = false,
    required this.follow,
    this.isFollowed,
    this.navigate,
    this.isFollowHidden = false,
  }) : super(key: key);
  late bool? isFollowHidden;
  late String? image = '';
  late String? name = '';
  late bool? isBackButtonHidden;
  late String? username = '';
  late int? followersCount = 0;
  late int? followingsCount = 0;
  late int? eventsCount = 0;
  late String? role = '';
  late VoidCallback follow;
  late int? isFollowed = 0;
  late VoidCallback? navigate;
  late bool? isNavigateDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.grey[900],
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)))),
      onPressed: () {
        if (isNavigateDisabled == false) {
          Navigator.pushNamed(context, '/other_profile', arguments: {
            'username': username!,
          });
        } else {
          return;
        }
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
                    isBackButtonHidden == false
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Ionicons.chevron_back_sharp,
                                size: 20,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    isFollowHidden == false
                        ? Align(
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
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: image ??
                        'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826',
                    imageBuilder: (_, provider) {
                      return CircleAvatar(
                        backgroundImage: provider,
                        radius: 50,
                      );
                    },
                    errorWidget: (_, errorMessage, widget) {
                      return Text(errorMessage);
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  username!,
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
                            followersCount!.toString(),
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
                            followingsCount!.toString(),
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
                                  eventsCount!.toString(),
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
