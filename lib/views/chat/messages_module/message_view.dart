import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/messages_module/components/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/models/injector.dart';
import 'package:provider/provider.dart';

class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatBloc>(context, listen: false);
    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, chatState) {
              if (chatState is InitChatState) {
                if (chatState.conversation == null) {
                  return EmptyMessageView(friend: chatState.friend);
                }
                return buildMessageList(chat.msgListStream);
              }

              return const Center(
                child: Text(
                  "Coi lại hộ cái state!",
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildMessageList(Stream<Iterable<Message>> stream) {
    return StreamBuilder<Iterable<Message>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final msgList = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: msgList!.length,
            itemBuilder: (context, index) {
              final message = msgList.elementAt(index);

              return MessageItem(message: message);
              // return Column(
              //   children: [
              //     if (indexShowTime == 1) ...[
              //       CluterMessagesTime(
              //         theme: appState.darkMode,
              //         time: state.listTime![index],
              //       ),
              //     ],
              //     // nhóm các mesage
              //     ClusterMessages(
              //       avatarFriend: state.friend.urlImage!,
              //       theme: appState.darkMode,
              //       isSender: isSender,
              //       messages: clusterMessage,
              //       isLastCluster: isLastClusterMessage,
              //     ),
              //   ],
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
