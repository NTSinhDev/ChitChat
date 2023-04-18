import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/components/input_messages_module/input_messages_module.dart';
import 'package:chat_app/views/chat/components/messages_module/message_view_module.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/messages_module/components/injector.dart';

class ChatScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final serverKey = context.watch<APIKeyProvider>().messagingServerKey;
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        currentUser: currentUser,
        conversation: conversation,
        friend: friendInfo,
        serverKey: serverKey,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: buildAppBar(context, friendInfo),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: conversation == null
                      ? EmptyMessageView(friend: friendInfo)
                      : const MessageViewModule(),
                ),
              ),
              const MessageInputModule(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserProfile friendInfo) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return AppBar(
      toolbarHeight: 64.h,
      elevation: 0,
      backgroundColor: AppColors(theme: theme).themeMode,
      leadingWidth: 40.w,
      leading: Container(
        margin: EdgeInsets.only(left: 10.w),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StateAvatar(
            urlImage: friendInfo.urlImage,
            userId: friendInfo.profile?.id,
            radius: 44.r,
          ),
          Spaces.w14,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friendInfo.profile!.fullName,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 15.r),
              ),
              PresenceStreamWidget(
                userId: friendInfo.profile!.id!,
                child: (presence) {
                  if (presence == null) return Container();
                  return Text(
                    presence.status
                        ? context.languagesExtension.onl
                        : "${TimeUtilities.differenceTime(context: context, earlier: presence.timestamp)} ${context.languagesExtension.ago}",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 10.r),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            FlashMessageWidget(
              context: context,
              message: 'Chưa làm gì hết!',
              type: FlashMessageType.info,
            );
          },
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }
}
