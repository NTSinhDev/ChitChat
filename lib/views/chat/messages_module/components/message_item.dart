import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/views/chat/messages_module/components/components_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageItem extends StatefulWidget {
  final Message message;
  const MessageItem({
    super.key,
    required this.message,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late bool isMessageInfo;
  late bool isMsgOfUser;
  @override
  void initState() {
    isMessageInfo = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.watch<ChatBloc>();
    isMsgOfUser = widget.message.senderId == chatBloc.currentUser.profile!.id
        ? true
        : false;
    final theme = context.watch<ThemeProvider>().isDarkMode;
    // UI
    final colorBG = theme ? darkGreyDarkMode : lightGreyLightMode;
    final colorSenderBG = theme ? darkBlue : lightBlue;
    final radius15 = Radius.circular(12.r);
    final crossAxisAlign =
        isMsgOfUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAxisAlign,
      children: [
        GestureDetector(
          // onTap: () => setState(() => _isMessageInfo = !_isMessageInfo),
          onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
            _bottomActionMsg(context),
          ),
          child: _message(colorSenderBG, colorBG, radius15),
        ),
        ..._infoMsgWidget(),
        ..._sendMsgFailedWidget(),
      ],
    );
  }

  Widget _message(colorSenderBG, colorBG, radius15) {
    if (widget.message.messageType == MessageType.image.toString()) {
      return ImageMessage(
        isMsgOfUser: isMsgOfUser,
        paths: widget.message.listNameImage,
      );
    }

    if (widget.message.messageType == MessageType.audio.toString()) {
      return AudioMessage(
        url: widget.message.nameRecord!,
        colorMsg: isMsgOfUser ? colorSenderBG : colorBG,
        borderMsg: BorderRadius.only(
          bottomLeft: isMsgOfUser ? radius15 : const Radius.circular(0),
          bottomRight: isMsgOfUser ? const Radius.circular(0) : radius15,
          topLeft: radius15,
          topRight: radius15,
        ),
        colorShadow: isMsgOfUser ? Colors.black45 : Colors.black12,
        mainAlign:
            isMsgOfUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      );
    }

    if (widget.message.messageType == MessageType.video.toString()) {
      return VideoMessage(
        urlList: widget.message.listNameImage,
        isMsgOfUser: isMsgOfUser,
      );
    }
    return TextMessage(isMsgOfUser: isMsgOfUser, text: widget.message.content!);
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
              // formatTime(widget.message.time),
              widget.message.stampTime.toIso8601String(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ];
    }

    return [];
  }

  SnackBar _bottomActionMsg(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 82.h,
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
