import 'package:chat_app/models/injector.dart';

class ConversationData {
  final Conversation conversation;
  final UserProfile friend;
  ConversationData({
    required this.conversation,
    required this.friend,
  });
}
