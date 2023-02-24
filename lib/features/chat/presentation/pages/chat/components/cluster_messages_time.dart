import 'package:chat_app/presentation/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CluterMessagesTime extends StatelessWidget {
  final bool theme;
  final String time;
  const CluterMessagesTime(
      {super.key, required this.theme, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: theme ? darkGreyDarkMode : lightGreyLightMode,
      ),
      child: Text(
        time,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
