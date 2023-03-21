import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/conversations/components/chat_room_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Conversations extends StatelessWidget {
  final Iterable<Conversation> conversations;
  const Conversations({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: conversations.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final conversation = conversations.elementAt(index);
          final friendProfile = conversationBloc.getFriendInfomation(
            id: _getFriendId(
              conversationBloc.currentUser.profile!.id!,
              conversation,
            ),
          );
          return ChatRoomWidget(
            conversation: conversation,
            friendProfile: friendProfile,
          );
        },
      ),
    );
  }

  String _getFriendId(String currentUserId, Conversation conversation) {
    if (conversation.listUser.length == 1) return conversation.listUser.first;

    return conversation.listUser.firstWhere(
      (element) => element != currentUserId,
    );
  }
}
