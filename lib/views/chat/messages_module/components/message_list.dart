import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    return StreamBuilder<Iterable<Message>>(
      stream: chatBloc.msgListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final msgList = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: msgList!.length,
            itemBuilder: (context, index) {
              final message = msgList.elementAt(index);
              return Container(
                child: Text(message.content!),
              );
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
          );
        } else {
          return const Center(
            child: Text(
              "Tạo một widget loading cho messageList để thay thế tôi",
            ),
          );
        }
      },
    );
  }
}
