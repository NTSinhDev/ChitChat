import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LargeRoundButton extends StatelessWidget {
  final String textButton;
  final VoidCallback onTap;
  const LargeRoundButton({
    super.key,
    required this.textButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 25.h),
        padding: EdgeInsets.symmetric(
          vertical: 25.h,
          horizontal: 25.w,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ResColors.customPurple,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            textButton.toUpperCase(),
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 3.5,
              wordSpacing: 4.0,
              fontSize: 18.r,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}
