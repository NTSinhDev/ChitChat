import 'package:chat_app/models/injector.dart';

abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  final String searchName;
  SearchingEvent({
    required this.searchName,
  });
}

class ComeBackSearchScreenEvent extends SearchEvent {}

class JoinConversationEvent extends SearchEvent {
  final List<String> userIDs;
  final UserProfile friend;
  JoinConversationEvent({
    required this.userIDs,
    required this.friend,
  });
}
