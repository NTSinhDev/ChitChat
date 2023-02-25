// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // final User currentUser;

  List<dynamic>? listDataRoom = [];
  List<dynamic>? listFriend = [];

  // Chat room
  List<dynamic> sourceChat = [];
  List<String> timeList = [];
  // User? friend;
  bool? friendPresence;

  // Friend
  List<dynamic>? requests = [];

  ChatBloc({
    this.listDataRoom,
    this.requests,
    // required this.currentUser,
    this.listFriend,
  }) : super(JoinAppState(listDataRoom!, listFriend)) {
    // checkConnectSocket();
    // chatRepository = ChatRepository(
    //   environment: Environment(isServerDev: true),
    // );

    // //* Room
    // on<JoinRoomEvent>(joinRoomEvent);
    // on<CheckHasRoomEvent>(checkHasRoomEvent);
    // on<ExitRoomEvent>(exitChatRoom);
    // //* Message
    // on<SendMessageEvent>(sendMessageEvent);
    // on<SendFilesEvent>(sendFilesEvent);
    // //* Friend
    // on<LookingForFriendEvent>(lookingForFriend);
    // on<FindUserEvent>(findUserEvent);
    // on<ExitFriendEvent>(exitLookingForFriend);
    // on<FriendRequestEvent>(friendRequestEvent);
    // on<BackToFriendRequestEvent>(backToFriendRequest);
    // on<AcceptFriendRequestEvent>(acceptFriendRequestEvent);
    // on<RemoveFriendRequest>(removeFriendRequest);
    // //* Search
    // on<InitLookingForChatEvent>(initLookingForChat);
    // on<ExitSearchEvent>(exitSearchFriend);
    // on<UpdatePresenceEvent>(updatePresenceEvent);
    // updateListDataRooms();
    // getFriendRequest();
    // updatePresence();
  }

  // updatePresenceEvent(UpdatePresenceEvent event, Emitter<ChatState> emit) {
  //   if (event.roomID != null) {
  //     return emit(
  //       HasSourceChatState(
  //         isOnl: friendPresence!,
  //         idRoom: event.roomID!,
  //         currentUser: currentUser,
  //         friend: friend!,
  //       ),
  //     );
  //   }
  //   if (state is LookingForChatState) {
  //     emit(LookingForChatState(listFriend: listFriend!));
  //   }
  //   if (state is JoinAppState) {
  //     emit(JoinAppState(listDataRoom!, listFriend));
  //   }
  // }

  // exitSearchFriend(ExitSearchEvent event, Emitter<ChatState> emit) {
  //   emit(JoinAppState(listDataRoom!, listFriend));
  // }

  // backToFriendRequest(BackToFriendRequestEvent event, Emitter<ChatState> emit) {
  //   emit(LookingForFriendState(init: true, requests: requests));
  // }

  // initLookingForChat(InitLookingForChatEvent event, Emitter<ChatState> emit) {
  //   emit(LookingForChatState(listFriend: listFriend!, init: true));
  // }

  // exitChatRoom(ExitRoomEvent event, Emitter<ChatState> emit) {
  //   socket.emit("exitRoom", event.roomID);
  //   emit(JoinAppState(listDataRoom!, listFriend));
  // }

  // exitLookingForFriend(ExitFriendEvent event, Emitter<ChatState> emit) {
  //   emit(JoinAppState(listDataRoom!, listFriend));
  // }

  // removeFriendRequest(
  //   RemoveFriendRequest event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   final result = await chatRepository.removeRequest(data: {
  //     "userID": currentUser.sId,
  //     "friendID": event.friendID,
  //   });
  //   if (result == null || result.result == -1) {
  //     return;
  //   }
  //   requests = result.data!;
  //   emit(LookingForFriendState(init: true, requests: requests));
  // }

  // acceptFriendRequestEvent(
  //   AcceptFriendRequestEvent event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   socket.emit(
  //     'acceptFriendRequest',
  //     {"userID": currentUser.sId, "friendID": event.friendID},
  //   );
  //   requests!.removeAt(event.index);
  //   emit(LookingForFriendState(init: true, requests: requests));
  //   await updateFriends();
  // }

  // Future updateFriends() async {
  //   socket.on("updateFriends", (data) {
  //     listFriend = data;
  //   });
  // }

  // updatePresence({String? roomID}) {
  //   socket.on("updatePresence", (data) {
  //     log("userID: ${data['userID']}");
  //     log("presence: ${data['presence']}");

  //     for (var i = 0; i < listDataRoom!.length; i++) {
  //       if (listDataRoom![i]['presence']['userID'] == data['userID']) {
  //         listDataRoom![i]['presence']['presence'] = data['presence'];
  //         log("update room");

  //         break;
  //       }
  //     }

  //     for (var i = 0; i < listFriend!.length; i++) {
  //       if (listFriend![i]['presence']['userID'] == data['userID']) {
  //         listFriend![i]['presence']['presence'] = data['presence'];
  //         listFriend = sortListUserToOnlState(listFriend!);
  //         log("update friend");

  //         break;
  //       }
  //     }

  //     if (friend != null && friend!.sId == data['userID']) {
  //       friendPresence = data['presence'];
  //     }

  //     add(UpdatePresenceEvent(roomID: roomID));
  //   });
  // }

  // lookingForFriend(LookingForFriendEvent event, Emitter<ChatState> emit) async {
  //   final friendRequests = await chatRepository.getFriendRequests(
  //     data: {'userID': currentUser.sId},
  //   );
  //   if (friendRequests == null || friendRequests.result == -1) {
  //     requests = [];
  //   }
  //   requests = friendRequests!.data!;
  //   emit(LookingForFriendState(init: true, requests: requests));
  // }

  // updateListDataRooms() {
  //   socket.on("getRooms", (data) {
  //     bool existedRoom = false;

  //     for (var i = 0; i < listDataRoom!.length; i++) {
  //       if (listDataRoom![i]['room']['_id'] == data['room']['_id']) {
  //         existedRoom = true;
  //         listDataRoom![i]['room'] = data['room'];
  //         break;
  //       }
  //     }

  //     if (existedRoom == false) {
  //       listDataRoom!.add(data);
  //     }
  //     listDataRoom = sortListRoomToLastestTime(listDataRoom!);
  //   });
  // }

  // friendRequestEvent(FriendRequestEvent event, Emitter<ChatState> emit) async {
  //   emit(LookingForFriendState(
  //     cuccessed: true,
  //     user: event.friend,
  //     addFriendSuccess: true,
  //   ));

  //   final time = DateFormat('kk:mm dd/MM/yyyy').format(DateTime.now());
  //   socket.emit(
  //     'addFriendRequest',
  //     {"userID": currentUser.sId, "friendID": event.friend.sId, "time": time},
  //   );
  //   await listenResponseRequestSuccess(event.friend);
  // }

  // Future listenResponseRequestSuccess(user) async {
  //   socket.on('addFriendRequestSuccess', (data) {
  //     if (data) {
  //       emit(LookingForFriendState(
  //         cuccessed: true,
  //         user: user,
  //         addFriendSuccess: true,
  //       ));
  //     }
  //   });
  // }

  // findUserEvent(FindUserEvent event, Emitter<ChatState> emit) async {
  //   emit(LookingForFriendState(finding: true));
  //   if (event.email == currentUser.email) {
  //     return emit(LookingForFriendState(failed: true));
  //   }
  //   final user = await chatRepository.findUser(
  //     data: {"email": event.email, "userID": currentUser.sId},
  //   );
  //   if (user == null || user.result == -1) {
  //     return emit(LookingForFriendState(failed: true));
  //   }
  //   emit(LookingForFriendState(
  //     user: user.data,
  //     cuccessed: true,
  //   ));
  // }

  // sendFilesEvent(SendFilesEvent event, Emitter<ChatState> emit) async {
  //   // upload files to server and get a response
  //   String paths;
  //   if (event.fileType == 'audio') {
  //     paths = await chatRepository.sendAudio(path: event.listPath[0]);
  //   } else {
  //     paths = await chatRepository.sendImages(paths: event.listPath);
  //   }

  //   final req = addMessageForAsynchronousThread(
  //     paths,
  //     event.fileType,
  //   );

  //   // push data for UI
  //   emit(HasSourceChatState(
  //     isOnl: friendPresence!,
  //     idRoom: event.roomID,
  //     sourceChat: sourceChat,
  //     listTime: timeList,
  //     currentUser: currentUser,
  //     friend: friend!,
  //   ));

  //   // add new message type img
  //   sendMessageBySocket(
  //     "đã gửi ${paths.length} ${event.fileType}",
  //     req[0], // message
  //     req[1], // is current time or not
  //     event.friendID,
  //     event.roomID,
  //   );
  //   await getSourceChat(event.roomID, friend!);
  // }

  // sendMessageBySocket(subMsg, msg, isCurrentTime, friendID, roomID) {
  //   if (!socket.connected) return log("SOCKET_IO NOT CONNECTION!");
  //   socket.emit("message", {
  //     'subMsg': subMsg,
  //     'message': msg,
  //     'isCurrentTime': isCurrentTime,
  //     'idUser': currentUser.sId,
  //     'idTarget': friendID,
  //     'idRoom': roomID,
  //   });
  // }

  // /// add a message to list message before send a request msg to server
  // List<dynamic> addMessageForAsynchronousThread(content, String type) {
  //   // prepare message data
  //   String date = DateFormat(dateMsg).format(DateTime.now());
  //   final msg = Message(
  //     idSender: currentUser.sId!,
  //     content: content,
  //     type: type,
  //     time: date,
  //     state: socket.connected ? 'loading' : 'failed',
  //   );

  //   // push message into source chat with state loading
  //   final data = addNewMessageWhileSocketWorking(
  //     msg: msg,
  //     date: date,
  //     currentUser: currentUser,
  //     listTime: timeList,
  //     sourceChat: sourceChat,
  //   );

  //   sourceChat = data[0]; // new source chat
  //   timeList = data[1]; // new time list
  //   return [msg, data[2]]; // Message , bool(is current time or not)
  // }

  // sendMessageEvent(SendMessageEvent event, Emitter<ChatState> emit) async {
  //   if (currentUser.sId == null) return;
  //   final req = addMessageForAsynchronousThread(event.message, 'text');

  //   emit(HasSourceChatState(
  //     isOnl: friendPresence!,
  //     idRoom: event.idRoom,
  //     sourceChat: sourceChat,
  //     listTime: timeList,
  //     currentUser: currentUser,
  //     friend: friend!,
  //   ));

  //   sendMessageBySocket('', req[0], req[1], event.friendID, event.idRoom);
  //   await getSourceChat(event.idRoom, friend!);
  // }

  // checkHasRoomEvent(CheckHasRoomEvent event, Emitter<ChatState> emit) async {
  //   String roomID = '';
  //   for (var element in listDataRoom!) {
  //     final room = ChatRoom.fromJson(element['room']);
  //     if (room.users!.contains(event.userID) &&
  //         room.users!.contains(event.friend.sId)) {
  //       roomID = room.sId!;
  //       break;
  //     }
  //   }
  //   if (roomID != '') {
  //     // Join room
  //     friend = event.friend;
  //     friendPresence = event.isOnl;
  //     if (!socket.connected) return;
  //     socket.emit(
  //       'joinRoom',
  //       {"roomID": roomID, "userID": currentUser.sId},
  //     );
  //     await getSourceChat(roomID, event.friend);
  //   } else {
  //     // Init room
  //     friend = event.friend;
  //     friendPresence = event.isOnl;

  //     emit(HasSourceChatState(
  //       isOnl: event.isOnl,
  //       idRoom: "",
  //       currentUser: currentUser,
  //       friend: event.friend,
  //     ));
  //   }
  // }

  // joinRoomEvent(JoinRoomEvent event, Emitter<ChatState> emit) async {
  //   friend = event.friend;
  //   friendPresence = event.isOnl;
  //   if (!socket.connected) return;
  //   socket.emit(
  //     'joinRoom',
  //     {"roomID": event.roomID, "userID": currentUser.sId},
  //   );
  //   await getSourceChat(event.roomID, event.friend);
  // }

  // Future getSourceChat(String roomID, User friend) async {
  //   socket.on('getSourceChat', (data) async {
  //     final objectSourceChat = await data['sourceChat'];
  //     final listKeyTime = data['sourceChat'].keys.toList();
  //     List<dynamic> listSourceChat = [];

  //     for (var element in listKeyTime) {
  //       listSourceChat.add(objectSourceChat[element]);
  //     }

  //     sourceChat = listSourceChat;
  //     timeList = listKeyTime;

  //     emit(HasSourceChatState(
  //       isOnl: friendPresence!,
  //       idRoom: roomID,
  //       sourceChat: listSourceChat,
  //       listTime: listKeyTime,
  //       currentUser: currentUser,
  //       friend: friend,
  //     ));
  //     socket.emit("viewMessage", {"roomID": roomID, "userID": currentUser.sId});
  //     updatePresence();
  //   });
  // }

  // getFriendRequest() {
  //   socket.on('friendRequest', (newRequest) {
  //     if (requests!.isNotEmpty) {
  //       requests!.add(newRequest);
  //     } else {
  //       requests = [newRequest];
  //     }
  //   });
  // }

  // checkConnectSocket() {
  //   // Connected
  //   socket.onConnect(
  //     (data) {
  //       log("Connection established");
  //       socket.emit("joinApp", currentUser.sId);
  //     },
  //   );

  //   // Connect error
  //   socket.onConnectError(
  //     (data) {
  //       log("connection failed + $data");
  //     },
  //   );

  //   // disconnect
  //   socket.onDisconnect(
  //     (data) {
  //       log("socketio Server disconnected");
  //     },
  //   );
  // }
}
