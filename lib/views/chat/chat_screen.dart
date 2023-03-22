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
          appBar: _chatScreenAppBarWidget(context),
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

  AppBar _chatScreenAppBarWidget(BuildContext context) {
    return AppBar(
      toolbarHeight: 72.h,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StateAvatar(
            urlImage: widget.friendInfo.urlImage,
            userId: widget.friendInfo.profile?.id ?? '',
            radius: 40.r,
          ),
          Spaces.w12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatName(
                  name: widget.friendInfo.profile!.fullName,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              StreamBuilder<DatabaseEvent>(
                  stream: PresenceRemoteDatasourceImpl().getPresence(
                    userID: widget.friendInfo.profile?.id ?? '',
                  ),
                  builder: (context, snapshotDBEvnet) {
                    final bool condition1 = snapshotDBEvnet.hasData;
                    final bool condition2 = snapshotDBEvnet.data != null;
                    final bool condition3 =
                        snapshotDBEvnet.data?.snapshot.value != null;
                    UserPresence? presence;
                    if (condition1 && condition2 && condition3) {
                      final data = snapshotDBEvnet.data!.snapshot;
                      final mapStringDynamic =
                          Map<String, dynamic>.from(data.value as Map);
                      presence =
                          UserPresence.fromMap(mapStringDynamic, data.key!);
                    }
                    if (presence != null && presence.status) {
                      return Text(
                        context.languagesExtension.onl,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 10.r),
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.info_circle_fill,
            color: Colors.blue,
            size: 30.r,
          ),
        ),
        Spaces.w4,
      ],
    );
  }
}
