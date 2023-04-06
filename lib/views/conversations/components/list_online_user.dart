import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/view_model/providers/friends_presence_provider.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:provider/provider.dart';

class ListOnlineUser extends StatefulWidget {
  final List<ConversationData> conversationsData;
  const ListOnlineUser({super.key, required this.conversationsData});

  @override
  State<ListOnlineUser> createState() => _ListOnlineUserState();
}

class _ListOnlineUserState extends State<ListOnlineUser> {
  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return ChangeNotifierProvider(
      create: (context) => FriendPresenceProvider(
          currentUser: conversationBloc.currentUser.profile!)
        ..getFriends(widget.conversationsData),
      child: Consumer<FriendPresenceProvider>(
        builder: (context, provider, child) {
          return Container(
            constraints: BoxConstraints(maxHeight: 114.h),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: provider.onlineFriends.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    if (index == 0) ...[
                      Spaces.w14,
                      _addNewFriend(context),
                    ],
                    _circleWidget(provider.onlineFriends[index], context),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _circleWidget(UserProfile friend, BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    bool showItem = true;
    return Visibility(
      visible: showItem,
      child: GestureDetector(
        onTap: () {},
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
              color: theme
                  ? ResColors.customNewLightPurple
                  : ResColors.purpleMessage(theme: theme),
              strokeWidth: 2,
              padding: EdgeInsets.all(2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
                child: Container(
                  height: 52.h,
                  width: 52.w,
                  color: theme
                      ? ResColors.darkGrey(isDarkmode: theme).withOpacity(0.5)
                      : Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.add_sharp,
                      color: ResColors.appColor(isDarkmode: theme),
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
