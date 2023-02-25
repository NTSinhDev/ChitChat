import 'package:chat_app/models/profile.dart';
import 'package:chat_app/views/setting/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPageController extends StatefulWidget {
  final Profile profile; 
  // final List<dynamic>? chatRooms;
  // final List<dynamic>? friendRequests;
  // final List<dynamic>? listFriend;
  const AppPageController({
    super.key, required this.profile,
    // required this.chatRooms,
    // this.friendRequests,
    // required this.listFriend,
  });

  @override
  State<AppPageController> createState() => _AppPageControllerState();
}

class _AppPageControllerState extends State<AppPageController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingScreen(profile: widget.profile);
    // return BlocProvider<ChatBloc>(
    //   create: (_) => ChatBloc(
    //     listDataRoom: widget.chatRooms!,
    //     requests: widget.friendRequests,
    //     currentUser: widget.authUser.user!,
    //     listFriend: widget.listFriend,
    //   ),
    //   child: BlocBuilder<ChatBloc, ChatState>(
    //     builder: (context, state) {
    //       if (state is HasSourceChatState) {
    //         return ChatScreen(
    //           friendID: state.friend.sId!,
    //           idRoom: state.idRoom,
    //         );
    //       }
    //       if (state is LookingForChatState) {
    //         return SearchScreen(listFriend: state.listFriend);
    //       }
    //       if (state is LookingForFriendState) {
    //         return const AddFriendScreen();
    //       }
    //       return AppManager(authUser: widget.authUser, socket: _socket);
    //     },
    //   ),
    // );
  }
}
