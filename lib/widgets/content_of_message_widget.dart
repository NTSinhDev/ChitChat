import 'package:chat_app/utils/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentOfMsgWidget extends StatelessWidget {
  final bool isSender;
  final String content;
  const ContentOfMsgWidget({
    super.key,
    this.isSender = true,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      overflow: TextOverflow.ellipsis,
      maxLines: maxValueInteger,
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(color: isSender ? Colors.white : null, fontSize: 14.r),
    );
  }
}
