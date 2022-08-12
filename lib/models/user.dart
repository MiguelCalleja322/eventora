import 'package:eventora/models/role.dart';

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
  Role? role;

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
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        username: json['username'],
        mobile: json['mobile'],
        avatar: json['avatar'],
        email: json['email'],
        website: json['website'],
        birthdate: json['birthdate'],
        followingCount: json['following_count'],
        followersCount: json['followers_count'],
        role: json['role']);
  }
}
