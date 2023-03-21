import 'package:chat_app/models/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatRoomWidget extends StatelessWidget {
  final Conversation conversation;
  final Future<UserProfile?> friendProfile;
  const ChatRoomWidget({
    super.key,
    required this.conversation,
    required this.friendProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final conversationBloc = context.watch<ConversationBloc>();

    return FutureBuilder<UserProfile?>(
        future: friendProfile,
        builder: (context, snapshot) {
          UserProfile? userProfile;
          if (snapshot.hasData) {
            userProfile = snapshot.data;
          }
          return ListTile(
            onTap: () {},
            visualDensity: const VisualDensity(vertical: 0.7),
            leading: StateAvatar(
              urlImage: userProfile?.urlImage ?? URLImage(),
              userId: userProfile?.profile?.id ?? '',
              radius: 60.r,
            ),
            title: Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
              child: Text(
                userProfile?.profile?.fullName ?? "Unknown",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            subtitle: Container(
              margin: EdgeInsets.only(bottom: 4.h),
              child: Text(
                _handleMessageContent(
                  context,
                  conversationBloc,
                  userProfile?.profile?.id ?? '',
                ),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // Text(
                //   formatTimeRoom(widget.chatRoom.lastMessage!.time),
                //   style: !_isNotification(context)
                //       ? Theme.of(context).textTheme.bodySmall
                //       : Theme.of(context).textTheme.bodySmall!.copyWith(
                //             fontWeight: FontWeight.w600,
                //           ),
                // ),
                // if (_isNotification(context)) ...[
                //   SizedBox(height: 14.h),
                //   Badge(
                //     alignment: AlignmentDirectional.topEnd,
                //     child: Text(
                //       "${widget.chatRoom.state}",
                //       style: Theme.of(context).textTheme.labelSmall!.copyWith(
                //             color: Colors.white,
                //             fontSize: 8.r,
                //           ),
                //     ),
                //   ),
                //   // Container(
                //   //   constraints: BoxConstraints(maxHeight: 20.h),
                //   //   child: CircleAvatar(
                //   //     backgroundColor: Colors.blue,
                //   //     child: Center(
                //   //       child: Text(
                //   //         "${widget.chatRoom.state}",
                //   //         style:
                //   //             Theme.of(context).textTheme.labelSmall!.copyWith(
                //   //                   color: Colors.white,
                //   //                   fontSize: 12.r,
                //   //                 ),
                //   //       ),
                //   //     ),
                //   //   ),
                //   // ),
                // ],
              ],
            ),
          );
        });
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
      return "${AppLocalizations.of(context)!.you}: ${conversation.lastMessage}";
    }
    return conversation.lastMessage;
  }
}
