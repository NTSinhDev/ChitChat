import 'dart:developer';

import 'package:chat_app/utils/convert.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:chat_app/views/chat/components/messages_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/models/injector.dart';

class MessageViewModule extends StatelessWidget {
  const MessageViewModule({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatBloc>();
    return SingleChildScrollView(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 0.h, 10.h),
      child: StreamBuilder<List<Message>>(
        stream: chat.messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: _timeClusterWidgets(snapshot.data!),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<Widget> _timeClusterWidgets(List<Message> data) {
    /*
    Lấy danh sách các cụm tin nhắn theo móc thời gian.
    Biến timeClusters sẽ là danh sách của các danh sách tin nhắn.
    Trong đó danh sách các tin nhắm là cụm các tin nhắn trong một ngày.
    */
    final timeClusters = ChitChatConvert.convertToTimeClusters(messages: data);

    /*
    Xây dựng cây widgets.
    Cây widget có dạng lặp lại theo thứ tự sau: 
      1. Widget chỉ móc thời gian cuộc hội thoại theo ngày.
      2. Widget chứa các cụm tin nhắn với mỗi cụm là danh sách tin nhắn của một người dùng.   
    */
    List<Widget> timeClusterWidgets = [];
    for (var i = 0; i < timeClusters.length; i++) {
      // Móc thời gian
      final timeHook = TimeHookOfMessagesCluster(
        time: timeClusters[i].first.stampTime,
      );
      timeClusterWidgets.add(timeHook);

      // Các cụm tin nhắn
      final messagesClustersData = ChitChatConvert.convertToMessagesClusters(
        messages: timeClusters[i],
      );
      final messagesClusterWidgets = getMessagesClusterWidgets(
        data: messagesClustersData,
        islast: i == timeClusters.length - 1,
      );
      timeClusterWidgets.add(messagesClusterWidgets);
    }
    return timeClusterWidgets;
  }

  Widget getMessagesClusterWidgets({
    required List<List<Message>> data,
    required bool islast,
  }) {
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; i++) {
      widgets.add(MessagesCluster(
        messages: data[i],
        isLastCluster: islast,
      ));
    }
    log('🚀log⚡ $widgets');
    return Column(children: widgets);
  }
}
