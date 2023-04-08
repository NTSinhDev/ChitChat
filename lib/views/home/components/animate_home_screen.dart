import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimateHomeScreen extends StatelessWidget {
  final double endTweenValue;
  final AppBar appbar;
  final Widget body;
  final Widget floatingBtn;
  const AnimateHomeScreen({
    super.key,
    required this.endTweenValue,
    required this.appbar,
    required this.body,
    required this.floatingBtn,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: endTweenValue),
      duration: const Duration(milliseconds: 450),
      builder: (context, value, child) {
        final radiusCircular =
            endTweenValue == 0 && value == 0 ? endTweenValue : 24.r;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0011)
            ..setEntry(0, 3, 250 * value)
            ..rotateY((pi / 6) * value),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radiusCircular),
              bottomLeft: Radius.circular(radiusCircular),
            ),
            child: Scaffold(
              appBar: appbar,
              body: body,
              floatingActionButton: floatingBtn,
            ),
          ),
        );
      },
    );
  }
}
