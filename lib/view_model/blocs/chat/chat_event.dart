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
