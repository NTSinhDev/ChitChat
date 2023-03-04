import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingMessage extends StatelessWidget {
  final bool isSender;
  final bool theme;
  final String content;
  final double width;
  const LoadingMessage({
    super.key,
    required this.isSender,
    required this.theme,
    required this.content,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // UI
    final colorBG = theme ? darkGreyDarkMode : lightGreyLightMode;
    final colorSenderBG = theme ? darkBlue : lightBlue;
    return Container(
      padding: EdgeInsets.all(12.h),
      width: width,
      decoration: BoxDecoration(
        color: isSender ? colorSenderBG : colorBG,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 14.h,
            width: 14.w,
            child: const CircularProgressIndicator(
              strokeWidth: 1.0,
              color: Colors.white,
            ),
          ),
          Spaces.w10,
          Text(
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
        ],
      ),
    );
  }
}
