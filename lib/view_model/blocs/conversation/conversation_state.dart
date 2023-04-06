part of 'conversation_bloc.dart';

abstract class ConversationState {}

class ConversationInitial extends ConversationState {
  final String userId;
  ConversationInitial({
    required this.userId,
  });
}
