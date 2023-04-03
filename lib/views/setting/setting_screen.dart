import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/setting/components/change_laguage_feature.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:chat_app/views/setting/components/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late UserProfile _userProfile;
late bool _theme;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    _userProfile = context.watch<AuthenticationBloc>().userProfile!;
    _theme = context.watch<ThemeProvider>().isDarkMode;
    // app states
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(_userProfile),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: _theme ? Alignment.topLeft : Alignment.bottomRight,
                  end: _theme ? Alignment.bottomRight : Alignment.topLeft,
                  colors: const [
                    ResColors.darkPurple,
                    ResColors.deepPurple,
                    ResColors.redAccent,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                width: 264.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spaces.h12,
                    _buildUserInformation(context),
                    _buildSettingOptions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOptions(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Change theme: lightmode, darkmode
          FeatureSetting(
            icon: themeProvider.isDarkMode
                ? CupertinoIcons.circle_righthalf_fill
                : CupertinoIcons.circle_lefthalf_fill,
            title: themeProvider.isDarkMode
                ? context.languagesExtension.lightmode
                : context.languagesExtension.darkmode,
            onTap: () {
              themeProvider.toggleTheme(
                isOn: !themeProvider.isDarkMode,
                userID: _userProfile.profile?.id ?? '',
              );
            },
          ),
          // Space
          SizedBox(
            width: 220.w,
            child: const Divider(
              thickness: 0.2,
              color: Colors.white,
            ),
          ),
          // Change language
          const ChangeLanguageFeature(),
          // Space
          SizedBox(
            width: 220.w,
            child: const Divider(
              thickness: 0.2,
              color: Colors.white,
            ),
          ),
          // Logout
          FeatureSetting(
            icon: Icons.logout,
            title: context.languagesExtension.logout,
            onTap: () {
              context.read<AuthenticationBloc>().add(LogoutEvent());
              Navigator.of(context).pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInformation(BuildContext context) {
    return Column(
      children: [
        const UserAvatar(),
        Spaces.h10,
        Text(
          _userProfile.profile!.fullName,
          maxLines: 4,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontSize: 20.h, color: Colors.white),
        ),
      ],
    );
  }
}
