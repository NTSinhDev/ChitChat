import 'package:chat_app/utils/enums.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class GetMessagesOfConversationEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent({
    required this.message,
  });
}

class SendFilesEvent extends ChatEvent {
  final List<String> files;
  final MessageType type;
  SendFilesEvent({
    required this.files,
    required this.type,
  });
}
