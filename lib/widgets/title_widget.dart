import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool isUpper;
  const TitleWidget({super.key, required this.title, required this.isUpper});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        isUpper ? title.toUpperCase() : title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
