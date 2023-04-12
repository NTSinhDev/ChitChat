import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

class ResDecorate {
  static BoxDecoration boxColor({required Color color}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.h),
          bottomLeft: Radius.circular(14.h),
        ),
      );
  static const boxBGAuth = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        AppColors.redAccent,
        AppColors.deepPurple,
        AppColors.deepPurple,
        AppColors.deepPurple,
        AppColors.redAccent,
      ],
    ),
  );

  static const boxShadowBlack38 = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(4, 4),
        blurRadius: 4,
      ),
    ],
  );

  static final paddingAuthLG = EdgeInsets.fromLTRB(
    40.w,
    62.h,
    40.w,
    0,
  );

  static final paddingAuthRG = EdgeInsets.fromLTRB(
    40.w,
    20.h,
    40.w,
    0,
  );
}
