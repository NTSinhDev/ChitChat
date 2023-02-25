import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

// Login page
const boxBGAuth = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      redAccent,
      deepPurple,
      deepPurple,
      deepPurple,
      redAccent,
    ],
  ),
);

final paddingAuthLG = EdgeInsets.fromLTRB(
  40.w,
  62.h,
  40.w,
  0,
);

final paddingAuthRG = EdgeInsets.fromLTRB(
  40.w,
  20.h,
  40.w,
  0,
);
