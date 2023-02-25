import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/views/chat/components/app_bar.dart';
import 'package:chat_app/views/chat/components/chat_input_field.dart';
import 'package:chat_app/views/chat/components/message_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String idRoom;
  final String friendID;
  const ChatScreen({
    super.key,
    required this.idRoom,
    required this.friendID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controllerChat = TextEditingController();

  @override
  void dispose() {
    _controllerChat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatBloc>(context, listen: false)
            .add(ExitRoomEvent(roomID: widget.idRoom));
        return false;
      },
      child: Scaffold(
        appBar: buildAppBar(
          context: context,
          roomID: widget.idRoom,
        ),
        body: Column(
          children: [
            // const MessageView(),
            ChatInputField(
              controllerChat: _controllerChat,
              idRoom: widget.idRoom,
              idFriend: widget.friendID,
            ),
          ],
        ),
      ),
    );
  }
}
