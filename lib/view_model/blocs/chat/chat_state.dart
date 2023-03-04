import 'package:chat_app/models/models_injector.dart';

abstract class ChatState {
  final UserProfile currentUser;
  final UserInformation friend;
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
