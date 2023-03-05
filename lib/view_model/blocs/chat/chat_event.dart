// ignore_for_file: public_member_api_docs, sort_constructors_first
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
