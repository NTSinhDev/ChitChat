import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:provider/provider.dart';

class ListOnlineUser extends StatelessWidget {
  final List<ConversationData> conversationsData;
  const ListOnlineUser({super.key, required this.conversationsData});
  @override
  Widget build(BuildContext context) {
    final friendProvider = context.read<FriendsProvider>();
    friendProvider.getFriends(conversationsData);
    List<UserProfile> onlineFriends = [];
    return StreamBuilder<List<UserProfile>>(
      stream: friendProvider.friendsStream,
      builder: (context, snapshot) {
        onlineFriends = snapshot.data ?? [];
        return Container(
          constraints: BoxConstraints(maxHeight: 114.h),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: onlineFriends.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  if (index == 0) ...[
                    Spaces.w14,
                    _addNewFriend(context),
                  ],
                  PresenceStreamWidget(
                    userId: onlineFriends[index].profile!.id!,
                    child: (presence) {
                      return Visibility(
                        visible: presence?.status ?? false,
                        child: _friendItem(
                          context,
                          friend: onlineFriends[index],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _friendItem(BuildContext context, {required UserProfile friend}) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final currentUser = context.watch<AuthenticationBloc>().userProfile!;
    return GestureDetector(
      onTap: () async {
        final conversation = context
            .read<ConversationBloc>()
            .getConversationData(friendId: friend.profile!.id!);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (nContext) {
              return ChatScreen(
                conversation: conversation,
                currentUser: currentUser,
                friendInfo: friend,
              );
            },
            settings: RouteSettings(
              name: conversation == null
                  ? null
                  : "conversation:${conversation.id}",
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        constraints: BoxConstraints(maxWidth: 62.w),
        child: Column(
          children: [
            StateAvatar(
              urlImage: friend.urlImage,
              userId: friend.profile?.id ?? '',
              radius: 60.r,
            ),
            Spaces.h4,
            Text(
              friend.profile?.fullName ?? "UNKNOWN",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white)
                  : Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addNewFriend(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        constraints: BoxConstraints(maxWidth: 62.w),
        child: Column(
          children: [
            Spaces.h2,
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(30.r),
              color: AppColors(themeMode: false).customNewPurple,
              strokeWidth: 2,
              padding: EdgeInsets.all(2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
                child: Container(
                  height: 52.h,
                  width: 52.w,
                  color: theme
                      ? AppColors.darkGrey(isDarkmode: theme).withOpacity(0.5)
                      : AppColors.lightGrey(isDarkmode: theme),
                  child: Center(
                    child: Icon(
                      Icons.add_sharp,
                      color: AppColors.appColor(isDarkmode: theme),
                      size: 20.r,
                    ),
                  ),
                ),
              ),
            ),
            Spaces.h4,
            Text(
              context.languagesExtension.add_friend,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white)
                  : Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
