import 'package:chat_app/res/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/media_message.dart';
import 'package:chat_app/views/chat/components/messages_module/components/text_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageItem extends StatefulWidget {
  final Message message;
  final MessageIndex? index;
  final bool? isLast;
  const MessageItem({
    super.key,
    required this.message,
    this.index,
    this.isLast,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late bool isMessageInfo;
  late bool isMsgOfUser;
  late final ChatBloc chatBloc;

  @override
  void initState() {
    chatBloc = context.read<ChatBloc>();
    isMsgOfUser = widget.message.senderId == chatBloc.currentUser.profile!.id
        ? true
        : false;
    isMessageInfo = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    // UI
    final colorBG = theme
        ? AppColors.darkGrey(isDarkmode: theme)
        : AppColors.lightGrey(isDarkmode: theme);
    final colorSenderBG = AppColors.blue(isDarkmode: theme);
    final radius15 = Radius.circular(12.r);
    final crossAxisAlign =
        isMsgOfUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxisAlign,
      children: [
        GestureDetector(
          onTap: () => setState(() => isMessageInfo = !isMessageInfo),
          onLongPress: () => showBottomAction(context),
          child: buildMessageByType(colorSenderBG, colorBG, radius15),
        ),
        // ..._infoMsgWidget(),
        ..._sendMsgFailedWidget(),
      ],
    );
  }

  Widget buildMessageByType(colorSenderBG, colorBG, radius15) {
    if (widget.message.messageType == MessageType.media.toString()) {
      return MediaMessage(message: widget.message, isMsgOfUser: isMsgOfUser);
    }

    if (widget.message.messageType == MessageType.audio.toString()) {
      return AudioMessage(
        url: widget.message.listNameImage.first,
        isMsgOfUser: isMsgOfUser,
      );
    }
    return TextMessage(
      isMsgOfUser: isMsgOfUser,
      text: widget.message.content!,
      index: widget.index,
      isLast: widget.isLast ?? false,
    );
  }

  List<Widget> _sendMsgFailedWidget() {
    if (widget.message.messageStatus == MessageStatus.notSend.toString()) {
      return [
        Spaces.h4,
        Row(
          children: [
            Text(
              "Không gửi được",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.red),
            ),
            SizedBox(width: 4.h),
            Icon(
              Icons.error,
              size: 16.h,
              color: Colors.red,
            ),
          ],
        ),
      ];
    }
    return [];
  }

  List<Widget> _infoMsgWidget() {
    if (isMessageInfo) {
      return [
        Spaces.h2,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đã xem',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(width: 14.w),
            Text(
              // formatTime(widget.message.stampTime.to),
              widget.message.stampTime.toIso8601String(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ];
    }

    return [];
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
