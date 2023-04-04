// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class UpdateFriendListEvent extends SearchEvent {
  final UserProfile? friendProfile;
  UpdateFriendListEvent({required this.friendProfile});
}
