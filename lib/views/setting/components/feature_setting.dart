import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;
  final Function()? onTap;
  const FeatureSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap, this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        margin: EdgeInsets.fromLTRB(
          14.w,
          0,
          6.w,
          0,
        ),
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: color,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 28.h,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: trailing,
    );
  }
}
