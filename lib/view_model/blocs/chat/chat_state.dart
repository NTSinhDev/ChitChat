import 'package:chat_app/models/injector.dart';

abstract class ChatState {
  final UserProfile currentUser;
  final UserProfile friend;
  ChatState({
    required this.currentUser,
    required this.friend,
  });
}

class InitChatState extends ChatState {
  final Conversation? conversation;
  InitChatState({
    required this.conversation,
    required super.currentUser,
    required super.friend,
  });
}
