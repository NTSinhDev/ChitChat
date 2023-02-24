import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeDarkMode extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onchange;
  const ChangeDarkMode({
    super.key,
    required this.isDarkMode,
    required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        margin: EdgeInsets.fromLTRB(
          14.w,
          0,
          6.w,
          0,
        ),
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: Colors.blue[400],
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.circle_lefthalf_fill,
            color: Colors.white,
            size: 28.h,
          ),
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.darkmode,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Container(
        margin: EdgeInsets.only(right: 16.w),
        child: Switch(
          activeColor: Colors.blue[400],
          value: isDarkMode,
          onChanged: (value) => onchange(value),
        ),
      ),
    );
  }
}
