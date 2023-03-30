import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/input_messages_module/input_messages_module.dart';
import 'package:chat_app/views/chat/messages_module/message_view.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'chat_screen_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile currentUser;
  final UserProfile friendInfo;
  final Conversation? conversation;

  const ChatScreen({
    super.key,
    required this.currentUser,
    this.conversation,
    required this.friendInfo,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        currentUser: widget.currentUser,
        conversation: widget.conversation,
        friend: widget.friendInfo,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: buildAppBar(context, widget.friendInfo),
          body: Column(
            children: const [
              MessageView(),
              InputMessagesModule(),
            ],
          ),
        ),
      ),
    );
  }
}
