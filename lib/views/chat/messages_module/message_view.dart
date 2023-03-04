import 'package:chat_app/views/chat/messages_module/components/cluster_messages.dart';
import 'package:chat_app/views/chat/messages_module/components/cluster_messages_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    super.key,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 0,
            itemBuilder: (context, index) {
              // int indexShowTime = 0;
              // bool isLastClusterTime = _checkIsLastCluster(
              //   index,
              //   0 - 1,
              // );
              // List<dynamic> sourceChatItem = state.sourceChat![index];
              // return Column(
              //   children: sourceChatItem.map((clusterMessage) {
              //     final isSender = _checkIsSender(
              //       clusterMessage,
              //       state.currentUser.sId,
              //     );
              //     bool isLastClusterMessage = false;
              //     if (isLastClusterTime) {
              //       isLastClusterMessage = _checkIsLastCluster(
              //         indexShowTime,
              //         sourceChatItem.length - 1,
              //       );
              //     }
              //     indexShowTime++;
              //     return Column(
              //       children: [
              //         if (indexShowTime == 1) ...[
              //           CluterMessagesTime(
              //             theme: appState.darkMode,
              //             time: state.listTime![index],
              //           ),
              //         ],
              //         ClusterMessages(
              //           avatarFriend: state.friend.urlImage!,
              //           theme: appState.darkMode,
              //           isSender: isSender,
              //           messages: clusterMessage,
              //           isLastCluster: isLastClusterMessage,
              //         ),
              //       ],
              //     );
              //   }).toList(),
              // );
            },
          ),
        ),
      ),
    );
  }

  // bool _checkIsSender(clusterMessage, id) {
  //   return Message.fromJson(clusterMessage[0]).idSender == id ? true : false;
  // }

  // bool _checkIsLastCluster(index, check) {
  //   return index == check ? true : false;
  // }
}