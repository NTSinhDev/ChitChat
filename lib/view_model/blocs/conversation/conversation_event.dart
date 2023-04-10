part of 'conversation_bloc.dart';

abstract class ConversationEvent {}

class ListenConversationsEvent extends ConversationEvent {}

class HandleNotificationServiceEvent extends ConversationEvent {
  final BuildContext context;
  final GlobalKey<NavigatorState> navigatorKey;
  final String serverKey;
  HandleNotificationServiceEvent({
    required this.context,
    required this.navigatorKey,
    required this.serverKey,
  });
}

class ReadConversationEvent extends ConversationEvent {
  final Conversation conversation;
  ReadConversationEvent({required this.conversation});
}
