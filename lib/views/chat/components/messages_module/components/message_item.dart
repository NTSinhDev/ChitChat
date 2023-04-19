import 'dart:developer';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/media_message.dart';
import 'package:chat_app/views/chat/components/messages_module/components/text_message.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
    this.isLastCluster,
    this.isOfLastCluster = false,
    required this.isMsgOfUser,
    this.isLastClusterByUser = false,
  });
  final Message message;
  // Là tin nhắn cuối cùng của cụm, chỉ dùng cho tin nhắn của bạn bè
  final bool? isLastCluster;
  // là tin nhắn của cụm cuối cùng, chỉ dùng cho tin nhắn của người dùng
  final bool isOfLastCluster;
  final bool isMsgOfUser;
  final bool isLastClusterByUser;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late final ChatBloc chatBloc;
  @override
  void initState() {
    chatBloc = context.read<ChatBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Row(
      mainAxisAlignment:
          widget.isMsgOfUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 3.8 / 5,
          ),
          child: GestureDetector(
            onLongPress: () => showBottomAction(context),
            child: buildMessageByType(),
          ),
        ),
        ...statusOfMsg(theme),
      ],
    );
  }

  List<Widget> statusOfMsg(bool theme) {
    if (widget.isLastClusterByUser &&
        widget.message.messageStatus == MessageStatus.viewed.toString()) {
      return [
        SizedBox(width: 4.w),
        SizedBox(
          height: 14.h,
          width: 14.w,
          child: StateAvatar(urlImage: chatBloc.friend.urlImage, radius: 14.r),
        ),
        SizedBox(width: 4.w),
      ];
    }
    if (widget.isOfLastCluster &&
        widget.message.messageStatus == MessageStatus.sent.toString()) {
      return [
        SizedBox(width: 4.w),
        Container(
          height: 12.h,
          width: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors(theme: theme).baseTheme,
          ),
          child: Center(
            child: Icon(
              FontAwesomeIcons.check,
              size: 10.r,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 6.w),
      ];
    }
    if (widget.isOfLastCluster &&
        widget.message.messageStatus == MessageStatus.sending.toString()) {
      return [
        SizedBox(width: 4.w),
        Container(
          height: 12.h,
          width: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors(theme: theme).baseTheme),
          ),
        ),
        SizedBox(width: 6.w),
      ];
    }

    if (widget.isOfLastCluster &&
        widget.message.messageStatus == MessageStatus.notSend.toString()) {
      return [
        SizedBox(width: 4.w),
        SizedBox(
          height: 14.h,
          width: 14.w,
          child: Icon(
            Icons.error,
            size: 14.r,
            color: Colors.red,
          ),
        ),
        SizedBox(width: 4.w),
      ];
    }
    return [Spaces.w22];
  }

  Widget buildMessageByType() {
    if (widget.message.messageType == MessageType.media.toString()) {
      return MediaMessage(
          message: widget.message, isMsgOfUser: widget.isMsgOfUser);
    }
    if (widget.message.messageType == MessageType.audio.toString()) {
      return AudioMessage(
        url: widget.message.listNameImage.first,
        isMsgOfUser: widget.isMsgOfUser,
      );
    }
    return TextMessage(
      isMsgOfUser: widget.isMsgOfUser,
      text: widget.message.content!,
      isLast: widget.isLastCluster ?? false,
    );
  }

  showBottomAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 52.h,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionMessage(
                icon: Icons.highlight_remove_rounded,
                action: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
                title: "Xóa",
              ),
              _actionMessage(
                icon: Icons.next_plan,
                title: "Chuyển tiếp",
              ),
              _actionMessage(
                icon: Icons.reply_outlined,
                title: "Trả lời",
              ),
              _actionMessage(
                icon: Icons.menu,
                title: "Xem thêm",
              ),
            ],
          )),
        ),
        duration: const Duration(seconds: maxValueInteger),
      ),
    );
  }

  Widget _actionMessage({
    required IconData icon,
    Function()? action,
    required String title,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: action,
          icon: Icon(icon),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}
