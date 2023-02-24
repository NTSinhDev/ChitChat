import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/data/models/chat_room.dart';
import 'package:chat_app/data/models/user_presence.dart';
import 'package:chat_app/presentation/widgets/chat_room_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';

class NewListChatRoom extends StatefulWidget {
  final List<dynamic> listRoom;
  final bool isGroup;
  final bool? isCall;
  const NewListChatRoom({
    Key? key,
    required this.listRoom,
    required this.isGroup,
    this.isCall,
  }) : super(key: key);

  @override
  State<NewListChatRoom> createState() => _NewListChatRoomState();
}

class _NewListChatRoomState extends State<NewListChatRoom> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    final maxHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.listRoom.length,
        itemBuilder: (BuildContext context, int index) {
          final roomData = widget.listRoom[index];
          final room = ChatRoom.fromJson(roomData['room']);
          final user = User.fromJson(roomData['user']);
          final presence = UserPresence.fromJson(roomData['presence']);
          return ChatRoomWidget(
            chatRoom: room,
            isDarkMode: appState.darkMode,
            isGroup: widget.isGroup,
            isCall: widget.isCall,
            user: user,
            presence: presence,
          );
        },
      ),
    );
  }
}
