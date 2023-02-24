// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/data/models/auth_user.dart';

abstract class ChatEvent {
  const ChatEvent();
}

//* Room
class GetDataAppEvent extends ChatEvent {}

class ExitRoomEvent extends ChatEvent {
  final String roomID;
  ExitRoomEvent({
    required this.roomID,
  });
}

class JoinRoomEvent extends ChatEvent {
  final String roomID;
  final User friend;
  final bool isOnl;
  JoinRoomEvent({
    required this.roomID,
    required this.friend,
    required this.isOnl,
  });
}

class CheckHasRoomEvent extends ChatEvent {
  final String userID;
  final User friend;
  final bool isOnl;
  CheckHasRoomEvent({
    required this.isOnl,
    required this.userID,
    required this.friend,
  });
}

//* Message
class SendMessageEvent extends ChatEvent {
  final String message;
  final String idRoom;
  final String friendID;
  SendMessageEvent({
    required this.message,
    required this.idRoom,
    required this.friendID,
  });
}

class SendFilesEvent extends ChatEvent {
  final List<String> listPath;
  final String fileType;
  final String roomID;
  final String friendID;
  SendFilesEvent({
    required this.fileType,
    required this.listPath,
    required this.roomID,
    required this.friendID,
  });
}

//* Friend
class LookingForFriendEvent extends ChatEvent {}

class ExitFriendEvent extends ChatEvent {}

class FindUserEvent extends ChatEvent {
  final String email;
  FindUserEvent({
    required this.email,
  });
}

class FriendRequestEvent extends ChatEvent {
  final dynamic friend;
  FriendRequestEvent({
    required this.friend,
  });
}

class BackToFriendRequestEvent extends ChatEvent {}

class AcceptFriendRequestEvent extends ChatEvent {
  final String friendID;
  final int index;
  AcceptFriendRequestEvent({
    required this.friendID,
    required this.index,
  });
}

class RemoveFriendRequest extends ChatEvent {
  final String friendID;
  RemoveFriendRequest({
    required this.friendID,
  });
}

//* Search
class InitLookingForChatEvent extends ChatEvent {}

class ExitSearchEvent extends ChatEvent {}

class UpdatePresenceEvent extends ChatEvent {
  final String? roomID;
  UpdatePresenceEvent({
    this.roomID,
  });
}
