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
    return StreamBuilder<Iterable<Message>>(
      stream: chat.messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            reverse: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            child: Column(
              children: _timeClusterWidgets(snapshot.data!.toList()),
            ),
          );
        }
        return const Center(
          child: Text(
            "Tạo một widget loading cho messageList để thay thế tôi",
          ),
        );
      },
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
      final timeHook = MessagesTimeCluster(
        time: timeClusters[i].first.stampTime,
      );
      timeClusterWidgets.add(timeHook);

      // Các cụm tin nhắn
      final messagesClustersData = ChitChatConvert.convertToMessagesClusters(
        messages: timeClusters[i],
      );
      final messagesClusterWidgets = getMessagesClusterWidgets(
        data: messagesClustersData,
      );
      timeClusterWidgets.add(messagesClusterWidgets);
    }
    return timeClusterWidgets;
  }

  Widget getMessagesClusterWidgets({required List<List<Message>> data}) {
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; i++) {
      widgets.add(MessagesCluster(messages: data[i]));
    }
    return Column(children: widgets);
  }
}
