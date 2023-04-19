import 'dart:developer';

import 'package:chat_app/utils/convert.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
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
      padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
      child: StreamBuilder<List<Message>>(
        stream: chat.messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: _timeClusterWidgets(snapshot.data!, context),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<Widget> _timeClusterWidgets(List<Message> data, BuildContext context) {
    final user = context.watch<AuthenticationBloc>().userProfile!.profile!;
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
        currentUserID: i == indexOfHaveUserMessage(timeClusters, user.id!)
            ? user.id
            : null,
      );
      timeClusterWidgets.add(messagesClusterWidgets);
    }
    return timeClusterWidgets;
  }

  int indexOfHaveUserMessage(
    List<List<Message>> timeClusters,
    String currentUserID,
  ) {
    for (int i = timeClusters.length - 1; i > -1; i--) {
      if (timeClusters[i].any((msg) => msg.senderId == currentUserID)) {
        return i;
      }
    }
    return -1;
  }

  Widget getMessagesClusterWidgets({
    required List<List<Message>> data,
    required bool islast,
    String? currentUserID,
  }) {
    /** Nếu currentUserID != null: 
     * -> data là danh sách cluster cuối cùng có chứa message của người dùng hiện tại
     * Bắt đầu tìm ra cluster cuối cùng của người dùng hiện tài và trả về MessagesCluster
     */
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; i++) {
      if (currentUserID != null) {
        final index = indexOfHaveUserMessage(data, currentUserID);
        widgets.add(MessagesCluster(
          messages: data[i],
          isLastCluster: islast,
          isLastClusterOfTimeCluster:
              data[i].first.senderId == currentUserID && i == index,
        ));
      } else {
        widgets.add(MessagesCluster(
          messages: data[i],
          isLastCluster: islast,
        ));
      }
    }
    return Column(children: widgets);
  }
}
