import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_bloc.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesCluster extends StatefulWidget {
  final List<Message> messages;
  final bool showTime;
  // final bool isLastCluster;
  const MessagesCluster({
    super.key,
    required this.messages,
    this.showTime = true,
    // required this.isLastCluster,
  });

  @override
  State<MessagesCluster> createState() => _MessagesClusterState();
}

class _MessagesClusterState extends State<MessagesCluster> {
  late final Profile currentUser;
  late final MessageStatus messageStatus;
  List<Widget> messagesClusterWidget = [];

  late final bool isCurrentUserMsg;
  late final CrossAxisAlignment crossAxisAlignment;

  @override
  void initState() {
    currentUser = context.read<AuthenticationBloc>().userProfile!.profile!;
    isCurrentUserMsg =
        widget.messages.first.senderId == currentUser.id! ? true : false;
    crossAxisAlignment =
        isCurrentUserMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    // _loading = false;
    // _sended = false;
    // _seen = false;
    initMessagesClusterWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Column(
          crossAxisAlignment: crossAxisAlignment,
          children: messagesClusterWidget,
        ),
        Spaces.h4,
        clusterGeneralInformation(),
        // ..._seenMessageWidget(),
      ],
    );
  }

  // List<Widget> _seenMessageWidget() {
  //   if (_seen && widget.isSender) {
  //     return [
  //       Spaces.h4,
  //       StateAvatar(urlImage: URLImage(), radius: 16.r),
  //     ];
  //   }
  //   return [];
  // }

  Widget clusterGeneralInformation() {
    return Row(
      mainAxisAlignment:
          isCurrentUserMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Spaces.w44,
        Text(
          DateFormat('kk:mm').format(widget.messages.last.stampTime),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColors.lightGrey(isDarkmode: true)),
        ),
        // if (messageStatus == MessageStatus.sent && isCurrentUserMsg) ...[
        //   Spaces.w4,
        //   Icon(
        //     Icons.check,
        //     size: 16.r,
        //     color: AppColors.darkGrey(isDarkmode: false),
        //   ),
        // ],
        // if (_loading && widget.isSender) ...[
        //   Spaces.w4,
        //   SizedBox(
        //     height: 12.h,
        //     width: 12.w,
        //     child: CircularProgressIndicator(
        //       strokeWidth: 1.3,
        //       color: AppColors.darkGrey(isDarkmode: false),
        //     ),
        //   ),
        // ],
        Spaces.w4,
      ],
    );
  }

  // _changeStateLastMsg(index) {
  //   if (index == widget.messages.length) {
  //     _loading = false;
  //     _sended = false;
  //     _seen = false;
  //     // final stateLastMsg = Message.fromJson(widget.messages.last).state;
  //     // if (stateLastMsg == 'viewed') {
  //     //   setState(() {
  //     //     _seen = true;
  //     //   });
  //     // } else if (stateLastMsg == 'loading') {
  //     //   setState(() {
  //     //     _loading = true;
  //     //   });
  //     // } else if (stateLastMsg == 'sended') {
  //     //   setState(() {
  //     //     _sended = true;
  //     //   });
  //     // }
  //   }
  // }

  initMessagesClusterWidget() {
    if (widget.messages.length == 1) {
      return messagesClusterWidget.add(
        MessageItem(
          message: widget.messages.first,
          index: MessageIndex.end,
          isLast: true,
        ),
      );
    }
    for (var i = 0; i < widget.messages.length; i++) {
      if (i == 0) {
        messagesClusterWidget.add(
          MessageItem(message: widget.messages[i], index: MessageIndex.first),
        );
      } else if (i == (widget.messages.length - 1)) {
        messagesClusterWidget.add(
          MessageItem(
            message: widget.messages[i],
            index: MessageIndex.end,
            isLast: true,
          ),
        );
      } else {
        messagesClusterWidget.add(
          MessageItem(message: widget.messages[i], index: MessageIndex.between),
        );
      }
    }
  }
}
