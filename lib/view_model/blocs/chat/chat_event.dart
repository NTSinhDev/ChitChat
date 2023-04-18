import 'package:chat_app/utils/enums.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final MessageType type;
    final List<String> files;
  SendMessageEvent({
    this.message = '',
    required this.type,
    this.files = const [],
  });
}
