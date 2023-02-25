// ignore_for_file: library_prefixes
import 'package:chat_app/models/profile.dart';
import 'package:chat_app/view_model/providers/app_state_provider.dart';
import 'package:chat_app/views/setting/components/change_dark_mode.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:chat_app/view_model/blocs/authentication/bloc_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  final Profile profile;
  const SettingScreen({
    super.key, required this.profile,
  });
  @override
  Widget build(BuildContext context) {
    // Size
    final sizedBox24 = SizedBox(height: 24.h);
    final sizedBox50 = SizedBox(height: 50.h);
    final sizedBox12 = SizedBox(height: 12.h);
    // app states
    AppStateProvider appStateProvider = context.watch<AppStateProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizedBox50,
          // UserAvatar(
          //   avatar: appStateProvider.urlImage,
          //   userID: authUser.user!.sId!,
          //   theme: appStateProvider.darkMode,
          // ),
          sizedBox12,
          Text(
            profile.fullName,
            maxLines: 4,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20.h,
                ),
          ),
          sizedBox50,
          ChangeDarkMode(
            isDarkMode: appStateProvider.darkMode,
            onchange: (value) => _changeDarkMode(value, context),
          ),
          sizedBox12,
          _changeLaguage(context),
          sizedBox12,
          FeatureSetting(
            icon: CupertinoIcons.person_circle,
            title: AppLocalizations.of(context)!.personal_info,
            color: Colors.deepPurple[400]!,
            onTap: () => _changeUserInfo(context),
          ),
          sizedBox12,
          _bannedUser(context),
          sizedBox12,
          _logout(context),
          sizedBox24,
        ],
      ),
    );
  }

  FeatureSetting _changeLaguage(BuildContext context) {
    return FeatureSetting(
      icon: CupertinoIcons.textformat,
      title: AppLocalizations.of(context)!.language,
      color: Colors.green[400]!,
      onTap: () {},
    );
  }

  FeatureSetting _logout(BuildContext context) {
    return FeatureSetting(
      icon: Icons.logout,
      title: AppLocalizations.of(context)!.logout,
      color: Colors.pink[400]!,
      onTap: () {
        context.read<AuthenticationBloc>().add(LogoutEvent());
      },
    );
  }

  FeatureSetting _bannedUser(BuildContext context) {
    return FeatureSetting(
      icon: CupertinoIcons.person_crop_circle_badge_exclam,
      title: AppLocalizations.of(context)!.list_ban,
      color: Colors.orange[400]!,
      onTap: () {},
    );
  }

  _changeDarkMode(bool value, BuildContext context) {

  }

  _changeUserInfo(BuildContext context) {

  }
}
