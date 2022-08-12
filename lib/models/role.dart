class Role {
  String? type;

  Role({this.type});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      type: json['type'],
    );
  }
}
