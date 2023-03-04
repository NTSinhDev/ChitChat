import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/models_injector.dart';
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
  final String? error;

  SearchInitialState({
    required this.friendsSubject,
    this.error,
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

class JoinConversationState extends SearchState {
  final Conversation conversation;
  final UserInformation friend;
  JoinConversationState({
    required this.conversation,
    required super.currentUser,
    required this.friend,
  });
}
