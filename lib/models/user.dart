class Users {
  final List<User>? users;

  Users({this.users});

  factory Users.fromJson(List<dynamic> json) {
    return Users(users: json.map((user) => User.fromJson(user)).toList());
  }
}

class User {
  String? name;
  String? username;
  String? mobile;
  String? avatar;
  String? email;
  String? website;
  String? birthdate;

  User({
    this.name,
    this.username,
    this.mobile,
    this.avatar,
    this.email,
    this.website,
    this.birthdate,
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
    );
  }
}
