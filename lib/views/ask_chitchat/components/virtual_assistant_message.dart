import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VirtualAssistantMessage extends StatelessWidget {
  const VirtualAssistantMessage({
    super.key,
    required this.userProfile,
    required this.msg,
    required this.chatIndex,
    required this.shouldAnimate,
  });

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth * 3 / 5),
      margin: EdgeInsets.only(top: 12.h),
      child: Row(
        mainAxisAlignment:
            chatIndex == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chatIndex == 1)
            Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 36.h,
              height: 36.h,
              child: CircleAvatar(
                backgroundImage: Image.asset(ImgAnmStrings.iChitchat).image,
              ),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth * 3 / 5),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: chatIndex == 0
                  ? theme
                      ? ResColors.darkPurple
                      : ResColors.deepPurpleAccent
                  : theme
                      ? ResColors.darkGrey(isDarkmode: theme)
                      : ResColors.lightGrey(isDarkmode: theme),
              borderRadius: BorderRadius.only(
                bottomLeft: chatIndex == 0
                    ? Radius.circular(32.r)
                    : const Radius.circular(0),
                bottomRight: chatIndex == 0
                    ? const Radius.circular(0)
                    : Radius.circular(32.r),
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: chatIndex == 0
                      ? theme
                          ? Colors.black38
                          : Colors.black45
                      : theme
                          ? Colors.black26
                          : Colors.black12,
                  offset: chatIndex == 0
                      ? const Offset(-1, -1)
                      : const Offset(1, -1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Text(
              msg,
              overflow: TextOverflow.ellipsis,
              maxLines: maxValueInteger,
              style: chatIndex == 0
                  ? Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.white)
                  : Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}
