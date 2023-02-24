import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StateBottomNavigationBar extends StatelessWidget {
  final IconData icon;
  final String? valueState;
  const StateBottomNavigationBar({
    super.key,
    required this.icon,
    this.valueState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: valueState != null
          ? [
              Icon(
                icon,
                size: 28.r,
              ),
              Positioned(
                top: -2.h,
                right: -2.h,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 20.h),
                  width: 20.h,
                  height: 20.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.h,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      valueState ?? '',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ]
          : [
              Icon(
                icon,
                size: 28.r,
              ),
            ],
    );
  }
}
