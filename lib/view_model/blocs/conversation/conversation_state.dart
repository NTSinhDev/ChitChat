part of 'conversation_bloc.dart';

abstract class ConversationState {}

class ConversationInitial extends ConversationState {
  final Stream<Iterable<Conversation>?> conversationsStream;
  final String userId;
  ConversationInitial({
    required this.conversationsStream,
    required this.userId,
  });
}