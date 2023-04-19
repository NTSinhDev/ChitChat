import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextMessage extends StatelessWidget {
  final bool isMsgOfUser;
  final String text;
  final bool isLast;
  const TextMessage({
    super.key,
    required this.isMsgOfUser,
    required this.text,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final friend = context.watch<ChatBloc>().friend;
    return MessageWidget(
      isSender: isMsgOfUser,
      friend: friend,
      showAvatar: isLast,
      child: ContentOfMsgWidget(content: text, isSender: isMsgOfUser),
    );
  }
}