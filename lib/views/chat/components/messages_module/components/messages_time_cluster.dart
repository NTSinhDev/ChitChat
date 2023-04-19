import 'package:chat_app/res/colors.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeHookOfMessagesCluster extends StatelessWidget {
  final DateTime time;
  const TimeHookOfMessagesCluster({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LanguageProvider>().locale;
    return Container(
      margin: EdgeInsets.only(top: 60.h, bottom: 20.h),
      child: Text(
        TimeUtilities.formatTimeOfMessagesCluster(time, local),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 12.r,
            ),
      ),
    );
  }
}
