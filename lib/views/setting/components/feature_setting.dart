import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  const FeatureSetting({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 6.w),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: Colors.lightBlue[500]!.withOpacity(0.2),
      ),
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 40.h,
          height: 40.h,
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 25.h,
            ),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontSize: 15.r),
        ),
      ),
    );
  }
}
