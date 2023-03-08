import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/input_messages_module/input_messages_module.dart';
import 'package:chat_app/views/chat/messages_module/message_view.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile currentUser;
  final UserInformation friendInfo;
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
            urlImage: widget.friendInfo.informations.urlImage,
            userId: widget.friendInfo.informations.profile?.id ?? '',
            radius: 40.r,
          ),
          Spaces.w12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatName(
                  name: widget.friendInfo.informations.profile!.fullName,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (widget.friendInfo.presence?.status ?? false) ...[
                Text(
                  AppLocalizations.of(context)!.onl,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 10.r),
                ),
              ]
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
