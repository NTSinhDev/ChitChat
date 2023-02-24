import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBtnWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color? backgroundColor;
  const CustomBtnWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 48.h,
        width: 92.w,
        child: Center(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
