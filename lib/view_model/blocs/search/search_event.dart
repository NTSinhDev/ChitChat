import 'package:chat_app/models/injector.dart';
import 'package:rxdart/rxdart.dart';

abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  final String searchName;
  SearchingEvent({
    required this.searchName,
  });
}

class JoinConversationEvent extends SearchEvent {
  final List<String> userIDs;
  final ReplaySubject<List<UserProfile>?> usersSubject;
  final UserProfile friend;
  // final UserPresence? userPresence;
  // final String? searchText;
  JoinConversationEvent({
    required this.userIDs,
    required this.friend, 
    required this.usersSubject,
  });
}
