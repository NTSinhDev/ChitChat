import 'package:chat_app/view_model/blocs/authentication/authentication_bloc.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeDarkmodeFeature extends StatelessWidget {
  const ChangeDarkmodeFeature({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FeatureSetting(
      icon: CupertinoIcons.circle_lefthalf_fill,
      title: AppLocalizations.of(context)!.darkmode,
      color: Colors.blue[400]!,
      trailing: Container(
        margin: EdgeInsets.only(right: 16.w),
        child: Switch(
          activeColor: Colors.blue[400],
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) => _changeDarkMode(value, themeProvider,context),
        ),
      ),
    );
  }

  _changeDarkMode(bool value, ThemeProvider themeProvider, context) async {
    final authBloc = Provider.of<AuthenticationBloc>(context, listen: false);

    await themeProvider.toggleTheme(
      isOn: value,
      userID: authBloc.userProfile?.profile?.id ?? '',
    );
  }
}
