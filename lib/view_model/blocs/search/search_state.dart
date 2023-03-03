import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:rxdart/rxdart.dart';

abstract class SearchState {
  final UserProfile currentUser;
  SearchState({
    required this.currentUser,
  });
}

// lấy danh sách bạn bè
class SearchInitialState extends SearchState {
  final ReplaySubject<List<UserProfile>?> friendsSubject;
  SearchInitialState({
    required this.friendsSubject,
    required super.currentUser,
  });
}

class SearchingState extends SearchState {
  final ReplaySubject<List<UserProfile>?>? usersSubject;
  final bool? loading;
  SearchingState({
    this.loading,
    this.usersSubject,
    required super.currentUser,
  });
}

class GoToConversationRoomSearchChatState extends SearchState {
  final Conversation conversation;
  final String? searchText;
  GoToConversationRoomSearchChatState({
    required this.conversation,
    required this.searchText,
    required super.currentUser,
  });
}
