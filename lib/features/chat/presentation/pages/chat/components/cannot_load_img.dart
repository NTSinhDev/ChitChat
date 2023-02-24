import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CannotLoadMsg extends StatelessWidget {
  final bool isSender;
  final bool theme;
  final String content;
  const CannotLoadMsg({
    super.key,
    required this.isSender,
    required this.theme,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorBG = theme ? darkGreyDarkMode : lightGreyLightMode;
    final colorSenderBG = theme ? darkBlue : lightBlue;
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: isSender ? colorSenderBG : colorBG,
      ),
      child: Text(
        content,
        overflow: TextOverflow.ellipsis,
        maxLines: maxValueInteger,
        style: isSender
            ? Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white)
            : Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
