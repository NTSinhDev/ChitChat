import 'package:chat_app/models/injector.dart';
import 'package:chat_app/views/conversations/components/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationsListView extends StatelessWidget {
  final List<ConversationData> conversations;
  const ConversationsListView({Key? key, required this.conversations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: conversations.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => _separatorBar(context),
      itemBuilder: (BuildContext context, int index) => ConversationItem(
        conversation: conversations[index].conversation,
        friendProfile: conversations[index].friend,
      ),
    );
  }

  Align _separatorBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width - 108.w,
        margin: EdgeInsets.only(right: 20.w),
        child: const Divider(),
      ),
    );
  }
}
