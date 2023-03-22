import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/conversations/components/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationsListView extends StatelessWidget {
  final Iterable<Conversation> conversations;
  const ConversationsListView({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: conversations.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width - 108.w,
          margin: EdgeInsets.only(right: 20.w),
          child: const Divider(),
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        final conversation = conversations.elementAt(index);
        final friendProfile = conversationBloc.getFriendInfomation(
          id: _getFriendId(
            conversationBloc.currentUser.profile!.id!,
            conversation,
          ),
        );
        return ConversationItem(
          conversation: conversation,
          friendProfile: friendProfile,
        );
      },
    );
  }

  String _getFriendId(String currentUserId, Conversation conversation) {
    if (conversation.listUser.length == 1) return conversation.listUser.first;

    return conversation.listUser.firstWhere(
      (element) => element != currentUserId,
    );
  }
}
