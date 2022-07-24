// ignore_for_file: non_constant_identifier_names

class Organizers {
  final List<Organizer>? organizers;

  Organizers({this.organizers});

  factory Organizers.fromJson(List<dynamic> json) {
    return Organizers(
        organizers:
            json.map((organizer) => Organizer.fromJson(organizer)).toList());
  }
}

class Organizer {
  int? id;
  String? name;
  String? username;
  String? mobile;
  String? avatar;
  String? email;
  String? website;
  String? birthdate;
  int? followersCount;
  int? followingCount;
  int? eventsCount;
  List<dynamic>? isFollowed;

  Organizer({
    this.id,
    this.name,
    this.username,
    this.mobile,
    this.avatar,
    this.email,
    this.website,
    this.birthdate,
    this.followersCount,
    this.followingCount,
    this.eventsCount,
    this.isFollowed,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        mobile: json['mobile'],
        avatar: json['avatar'],
        email: json['email'],
        website: json['website'],
        birthdate: json['birthdate'],
        followersCount: json['followers_count'],
        followingCount: json['following_count'],
        eventsCount: json['events_count'],
        isFollowed: json['followers']);
  }
}
