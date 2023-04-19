import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_bloc.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesCluster extends StatelessWidget {
  final List<Message> messages;
  final bool isLastCluster;
  final bool isLastClusterOfTimeCluster;
  const MessagesCluster({
    super.key,
    this.isLastClusterOfTimeCluster = false,
    required this.messages,
    required this.isLastCluster,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUserMsg = messages.first.senderId ==
            context.watch<AuthenticationBloc>().userProfile!.profile!.id!
        ? true
        : false;

    return Column(
      crossAxisAlignment:
          isCurrentUserMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: isCurrentUserMsg
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: _initMessagesClusterWidget(isCurrentUserMsg),
        ),
        Spaces.h4,
        Row(
          mainAxisAlignment: isCurrentUserMsg
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
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
        ),
      ],
    );
  }

  List<Widget> _initMessagesClusterWidget(bool isCurrentUserMsg) {
    List<Widget> messagesClusterWidget = [];
    if (messages.length == 1) {
      messagesClusterWidget.add(
        MessageItem(
          message: messages.first,
          isLastCluster: true,
          isOfLastCluster: isLastCluster,
          isMsgOfUser: isCurrentUserMsg,
          isLastClusterByUser: isLastClusterOfTimeCluster,
        ),
      );
      return messagesClusterWidget;
    }
    for (var i = 0; i < messages.length; i++) {
      if (i == 0) {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            isOfLastCluster: isLastCluster,
            isMsgOfUser: isCurrentUserMsg,
          ),
        );
      } else if (i == (messages.length - 1)) {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            isLastCluster: true,
            isOfLastCluster: isLastCluster,
            isMsgOfUser: isCurrentUserMsg,
            isLastClusterByUser: isLastClusterOfTimeCluster,
          ),
        );
      } else {
        messagesClusterWidget.add(
          MessageItem(
            message: messages[i],
            isOfLastCluster: isLastCluster,
            isMsgOfUser: isCurrentUserMsg,
          ),
        );
      }
    }
    return messagesClusterWidget;
  }
}
