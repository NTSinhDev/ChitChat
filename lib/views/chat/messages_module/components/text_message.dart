import 'package:chat_app/res/colors.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TextMessage extends StatelessWidget {
  final bool isMsgOfUser;
  final String text;
  const TextMessage({super.key, required this.isMsgOfUser, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;

    final colorBG = theme
        ? ResColors.darkGrey(isDarkmode: theme)
        : ResColors.lightGrey(isDarkmode: theme);
    final colorSenderBG = ResColors.blue(isDarkmode: theme);
    final radius15 = Radius.circular(12.r);
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth * 4 / 5),
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: isMsgOfUser ? colorSenderBG : colorBG,
        borderRadius: BorderRadius.only(
          bottomLeft: isMsgOfUser ? radius15 : const Radius.circular(0),
          bottomRight: isMsgOfUser ? const Radius.circular(0) : radius15,
          topLeft: radius15,
          topRight: radius15,
        ),
        boxShadow: [
          BoxShadow(
            color: isMsgOfUser ? Colors.black45 : Colors.black12,
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxValueInteger,
        style: isMsgOfUser
            ? Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white)
            : Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
