import 'package:eventora/models/user.dart';

class Comments {
  final List<dynamic>? comments;

  Comments({this.comments});

  factory Comments.fromJson(List<dynamic> json) {
    return Comments(
        comments: json.map((comment) => Comment.fromJson(comment)).toList());
  }
}

class Comment {
  int? id;
  String? label;
  int? commentLikesCount;
  User? user;

  Comment({
    this.id,
    this.label,
    this.commentLikesCount,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        label: json['label'],
        commentLikesCount: json['comment_likes_count'],
        user: User.fromJson(json['user']));
  }
}
