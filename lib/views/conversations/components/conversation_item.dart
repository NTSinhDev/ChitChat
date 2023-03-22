import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';

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
    // final theme = context.watch<ThemeProvider>().isDarkMode;
    final conversationBloc = context.watch<ConversationBloc>();

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
                  differenceInCalendarDaysLocalization(
                    conversation.stampTimeLastText,
                    context,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
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

  String differenceInCalendarDaysLocalization(
      DateTime earlier, BuildContext? context) {
    if (context != null) {
      DateTime later = DateTime.now();
      if (later.difference(earlier).inHours >= 0 &&
          later.difference(earlier).inHours < 24) {
        if (later.difference(earlier).inMinutes >= 0 &&
            later.difference(earlier).inMinutes < 1) {
          return "${later.difference(earlier).inSeconds} ${context.languagesExtension.seconds}";
        } else if (later.difference(earlier).inMinutes >= 1 &&
            later.difference(earlier).inMinutes < 60) {
          return "${later.difference(earlier).inMinutes} ${context.languagesExtension.minutes}";
        } else if (later.difference(earlier).inMinutes >= 60) {
          return "${later.difference(earlier).inHours} ${context.languagesExtension.hours}";
        }
      } else if (later.difference(earlier).inHours >= 24 &&
          later.difference(earlier).inHours < 720) {
        return "${later.difference(earlier).inDays} ${context.languagesExtension.days}";
      } else {
        int month = 1;
        month = (month * later.difference(earlier).inDays / 30).round();
        return "$month ${context.languagesExtension.months}";
      }
    }
    return "";
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
    if (conversationUserId == conversationBloc.currentUser.profile!.id!) {
      return "${context.languagesExtension.you}: ${conversation.lastMessage}";
    }
    return conversation.lastMessage;
  }
}
