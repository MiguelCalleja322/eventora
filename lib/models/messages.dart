import 'package:eventora/models/user.dart';

class Conversations {
  final Message message;

  Conversations({required this.message});
}

class Conversation {
  final User user;
  final List<Message> message;

  Conversation({
    required this.user,
    required this.message,
  });
}

class Message {
  final int conversationId;
  final int userId;
  final String message;
  final String? media;
  final String? metadata;
  final bool? isRead;

  Message({
    required this.conversationId,
    required this.userId,
    required this.message,
    this.media,
    this.metadata,
    this.isRead,
  });
}
