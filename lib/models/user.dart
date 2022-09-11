import 'package:eventora/models/events.dart';

class User {
  String? name;
  String? username;
  String? mobile;
  String? avatar;
  String? email;
  String? website;
  String? birthdate;
  int? followingCount;
  int? followersCount;
  int? eventsCount;
  String? role;
  Events? events;

  User({
    this.name,
    this.username,
    this.mobile,
    this.avatar,
    this.email,
    this.website,
    this.birthdate,
    this.followingCount,
    this.followersCount,
    this.eventsCount,
    this.role,
    this.events,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      mobile: json['mobile'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      birthdate: json['birthdate'] ?? '',
      followingCount: json['following_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      eventsCount: json['events_count'] ?? 0,
      role: json['role'],
      events: Events.fromJson(json['events'] ?? []),
    );
  }
}
