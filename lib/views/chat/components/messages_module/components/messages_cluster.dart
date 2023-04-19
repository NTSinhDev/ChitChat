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

class MessagesCluster extends StatelessWidget {
  final List<Message> messages;
  final bool showTime;
  final bool isLastCluster;
  const MessagesCluster({
    super.key,
    required this.messages,
    this.showTime = true,
    required this.isLastCluster,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.read<AuthenticationBloc>().userProfile!.profile!;
    final isCurrentUserMsg =
        messages.first.senderId == currentUser.id! ? true : false;
    final crossAxisAlignment =
        isCurrentUserMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Column(
          crossAxisAlignment: crossAxisAlignment,
          children: initMessagesClusterWidget(),
        ),
        Spaces.h4,
        clusterGeneralInformation(isCurrentUserMsg, context),
        // ..._seenMessageWidget(),
      ],
    );
  }

  // List<Widget> _seenMessageWidget() {
  //   if (_seen && isSender) {
  //     return [
  //       Spaces.h4,
  //       StateAvatar(urlImage: URLImage(), radius: 16.r),
  //     ];
  //   }
  //   return [];
  // }

  Widget clusterGeneralInformation(isCurrentUserMsg, BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCurrentUserMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Spaces.w44,
        Text(
          DateFormat('kk:mm').format(messages.last.stampTime),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColors.lightGrey(isDarkmode: true)),
        ),
        Spaces.w22,
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

  List<Widget> initMessagesClusterWidget() {
    List<Widget> messagesClusterWidget = [];
    if (messages.length == 1) {
      messagesClusterWidget.add(
        MessageItem(
          message: messages.first,
          index: MessageIndex.end,
          isLast: true,
          isOfLastCluster: isLastCluster,
        ),
      );
      return messagesClusterWidget;
    }
    for (var i = 0; i < messages.length; i++) {
      if (i == 0) {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            index: MessageIndex.first,
            isOfLastCluster: isLastCluster,
          ),
        );
      } else if (i == (messages.length - 1)) {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            index: MessageIndex.end,
            isLast: true,
            isOfLastCluster: isLastCluster,
          ),
        );
      } else {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            index: MessageIndex.between,
            isOfLastCluster: isLastCluster,
          ),
        );
      }
    }
    return messagesClusterWidget;
  }
}
