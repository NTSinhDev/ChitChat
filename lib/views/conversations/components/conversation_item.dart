import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final Future<UserProfile?> friendProfile;
  const ConversationItem({
    super.key,
    required this.conversation,
    required this.friendProfile,
  });

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.watch<ConversationBloc>();
    final locale = context.watch<LanguageProvider>().locale;

    return FutureBuilder<UserProfile?>(
      future: friendProfile,
      builder: (context, snapshot) {
        UserProfile? userProfile;
        if (snapshot.hasData) {
          userProfile = snapshot.data;
        }
        return ListTile(
          onTap: () async {
            if (userProfile == null) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (nContext) {
                  return ChatScreen(
                    conversation: conversation,
                    currentUser: conversationBloc.currentUser,
                    friendInfo: userProfile!,
                  );
                },
                settings: RouteSettings(
                  name: "conversation:${conversation.id}",
                ),
              ),
            );
          },
          leading: StateAvatar(
            urlImage: userProfile?.urlImage ?? URLImage(),
            userId: userProfile?.profile?.id ?? '',
            radius: 56.r,
          ),
          title: Container(
            margin: EdgeInsets.only(bottom: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userProfile?.profile?.fullName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 14.r),
                ),
                Text(
                  TimeUtilities.formatTime(
                    conversation.stampTimeLastText,
                    locale,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          subtitle: Text(
            _handleMessageContent(
              context,
              conversationBloc,
              userProfile?.profile?.id ?? '',
            ),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 13.r),
          ),
          // trailing: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     // if (_isNotification(context)) ...[
          //     //   SizedBox(height: 14.h),
          //     //   Badge(
          //     //     alignment: AlignmentDirectional.topEnd,
          //     //     child: Text(
          //     //       "${widget.chatRoom.state}",
          //     //       style: Theme.of(context).textTheme.labelSmall!.copyWith(
          //     //             color: Colors.white,
          //     //             fontSize: 8.r,
          //     //           ),
          //     //     ),
          //     //   ),

          //     // ],
          //   ],
          // ),
        );
      },
    );
  }

  // bool _isNotification(BuildContext context) {
  //   final currentUserID = context.watch<ConversationBloc>().currentUser.profile?.id ?? '';
  //   String senderID = conversation. widget.chatRoom.lastMessage!.idSender;
  //   int value = widget.chatRoom.state!;
  //   if (senderID != currentUserID && value > 0) {
  //     return true;
  //   }
  //   return false;
  // }

  String _handleMessageContent(
    BuildContext context,
    ConversationBloc conversationBloc,
    String conversationUserId,
  ) {
    log('🚀log⚡ $conversationUserId == ${conversationBloc.currentUser.profile!.id!}');
    if (conversation.listUser.first ==
        conversationBloc.currentUser.profile!.id!) {
      return "${context.languagesExtension.you}: ${conversation.lastMessage}";
    }
    return conversation.lastMessage;
  }
}