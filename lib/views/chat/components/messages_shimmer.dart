import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/content_of_message_widget.dart';
import 'package:chat_app/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringMessages extends StatelessWidget {
  const ShimmeringMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final chatBloc = context.watch<ChatBloc>();
    return Column(
      children: [
        Shimmer(
          gradient: LinearGradient(
            colors: _colors(theme),
          ),
          child: Column(children: _originalData(chatBloc)),
        ),
        Shimmer(
          gradient: LinearGradient(
            colors: _colors(theme),
          ),
          child: Column(children: _originalData(chatBloc)),
        ),
      ],
    );
  }

  List<Color> _colors(bool isDarkmode) {
    return isDarkmode
        ? [
            Colors.grey[400]!,
            Colors.grey,
            Colors.grey[400]!,
          ]
        : [
            Colors.grey[300]!,
            Colors.grey[400]!,
            Colors.grey[300]!,
          ];
  }

  List<Widget> _originalData(ChatBloc chatBloc) {
    return [
      Spaces.h60,
      _blockCenter(),
      Spaces.h15,
      _messageOfFriend(
        chatBloc,
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      Spaces.h4,
      _blockLeft(),
      Spaces.h15,
      _messageOfUser(chatBloc, 'aaaaaaaaaaaaa'),
      _messageOfUser(
        chatBloc,
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      Spaces.h4,
      _blockRight(),
      Spaces.h15,
      _messageOfFriend(
        chatBloc,
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      Spaces.h4,
      _blockLeft(),
      Spaces.h15,
      _messageOfUser(
        chatBloc,
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      Spaces.h4,
      _blockRight()
    ];
  }

  Widget _messageOfUser(ChatBloc chatBloc, String content) {
    return MessageWidget(
      friend: chatBloc.friend,
      isSender: true,
      child: ContentOfMsgWidget(content: content),
    );
  }

  Widget _messageOfFriend(ChatBloc chatBloc, String content) {
    return MessageWidget(
      friend: chatBloc.friend,
      showAvatar: true,
      isSender: false,
      child: ContentOfMsgWidget(content: content),
    );
  }

  Row _blockRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 100.w,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _blockLeft() {
    return Row(
      children: [
        Spaces.w44,
        Container(
          width: 100.w,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _blockCenter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
