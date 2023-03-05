import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/views/chat/messages_module/components/components_injector.dart';
import 'package:chat_app/views/chat/messages_module/components/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, chatState) {
              if (chatState is InitChatState) {
                if (chatState.conversation == null) {
                  return EmptyMessage(friend: chatState.friend);
                }
                return MessageList();
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

  // bool _checkIsSender(clusterMessage, id) {
  //   return Message.fromJson(clusterMessage[0]).idSender == id ? true : false;
  // }

  // bool _checkIsLastCluster(index, check) {
  //   return index == check ? true : false;
  // }
}
