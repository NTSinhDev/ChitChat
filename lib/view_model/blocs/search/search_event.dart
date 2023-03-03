abstract class SearchEvent {}

class InitializeSearchChatEvent extends SearchEvent {
  InitializeSearchChatEvent();
}

class SearchingEvent extends SearchEvent {
  final String searchName;
  SearchingEvent({
    required this.searchName,
  });
}

// class GoToConversationRoomSearchChatEvent extends SearchEvent {
//   final List<String> listUserId;
//   final UserPresence? userPresence;
//   final String? searchText;
//   GoToConversationRoomSearchChatEvent({
//     required this.listUserId,
//     required this.userPresence,
//     required this.searchText,
//   });
// }