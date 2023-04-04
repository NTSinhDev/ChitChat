import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';

class ListOnlineUser extends StatelessWidget {
  const ListOnlineUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitialState) {
          return StreamBuilder<List<UserProfile>?>(
            stream: state.friendsSubject,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final friendList = snapshot.data!;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  constraints: BoxConstraints(maxHeight: 120.h),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: friendList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          if (index == 0) ...[
                            _addNewFriend(context),
                          ],
                          _friendWidget(friendList[index], context),
                        ],
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _friendWidget(
    UserProfile friend,
    BuildContext context,
  ) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return GestureDetector(
      onTap: () {},
      child: Center(
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
              SizedBox(height: 4.h),
              Text(
                friend.profile?.fullName ?? "UNKNOWN",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
      child: Center(
        child: Container(
          margin: EdgeInsets.only(right: 12.w),
          constraints: BoxConstraints(maxWidth: 62.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(30.r),
                color: ResColors.purpleMessage(theme: theme),
                strokeWidth: 1.5,
                padding: EdgeInsets.all(2.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.r),
                  ),
                  child: Container(
                    height: 52,
                    width: 52,
                    color: theme ? ResColors.mdblack : Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.add_sharp,
                        color: ResColors.appColor(isDarkmode: theme),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
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
      ),
    );
  }
}
