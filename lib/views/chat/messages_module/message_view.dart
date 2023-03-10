import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/messages_module/components/components_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/models/injector.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    super.key,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late final ChatBloc chat;

  @override
  void initState() {
    super.initState();
    chat = context.read<ChatBloc>();
  }

  @override
  Widget build(BuildContext context) {
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
                  return EmptyMessage(friend: chatState.friend);
                }
                return _messageListWidget(chat.msgListStream);
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

  Widget _messageListWidget(Stream<Iterable<Message>> stream) {
    return StreamBuilder<Iterable<Message>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final msgList = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: msgList!.length,
            itemBuilder: (context, index) {
              final message = msgList.elementAt(index);
              // init clustermessage

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
