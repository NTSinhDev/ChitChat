import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeDarkmodeFeature extends StatelessWidget {
  final String userID;
  const ChangeDarkmodeFeature({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FeatureSetting(
      icon: CupertinoIcons.circle_lefthalf_fill,
      title: context.languagesExtension.darkmode,
      // color: Colors.blue[400]!,
      trailing: Container(
        margin: EdgeInsets.only(right: 16.w),
        child: Switch(
          activeColor: Colors.blue[400],
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) async => await themeProvider.toggleTheme(
            isOn: value,
            userID: userID,
          ),
        ),
      ),
    );
  }
}
