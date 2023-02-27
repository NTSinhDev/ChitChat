import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/core/helpers/loading/loading_screen.dart';
import 'package:chat_app/core/helpers/notify/flash_message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/view_model/blocs/setting/setting_bloc.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/views/setting/components/change_laguage_feature.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:chat_app/view_model/blocs/authentication/bloc_injector.dart';
import 'package:chat_app/views/setting/components/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/change_darkmode_feature.dart';

class SettingScreen extends StatelessWidget {
  final UserProfile userProfile;
  const SettingScreen({
    super.key,
    required this.userProfile,
  });
  @override
  Widget build(BuildContext context) {
    // app states
    AppStateProvider appStateProvider = context.watch<AppStateProvider>();
    final sizedBox24 = SizedBox(height: 24.h);
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(userProfile),
      child: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingInitial) {
            if (state.loading) {
              LoadingScreen().show(context: context);
            } else {
              LoadingScreen().hide();
            }
            if (state.error != null && state.error!) {
              FlashMessage(
                context: context,
                message: AppLocalizations.of(context)!.could_not_update_avatar,
                type: FlashMessageType.error,
              );
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sizedBox24,
            _buildUserInformation(context),
            sizedBox24,
            _buildSettingOptions(context, appStateProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOptions(BuildContext context, appStateProvider) {
    // Size
    final sizedBox24 = SizedBox(height: 24.h);
    final sizedBox12 = SizedBox(height: 12.h);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     offset: Offset(0, 20),
          //     blurRadius: 20,
          //   ),
          // ],
          color: Colors.blue[100],
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(32.h),
          //   topRight: Radius.circular(32.h),
          // ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizedBox24,
              const ChangeDarkmodeFeature(),
              sizedBox12,
              const ChangeLanguageFeature(),
              sizedBox12,
              FeatureSetting(
                icon: CupertinoIcons.person_circle,
                title: AppLocalizations.of(context)!.personal_info,
                color: Colors.deepPurple[400]!,
                onTap: () {
                  FlashMessage(
                    context: context,
                    message: "đây là nội dung thông báo",
                    type: FlashMessageType.info,
                  );
                },
              ),
              sizedBox12,
              FeatureSetting(
                icon: Icons.error_outline,
                title: AppLocalizations.of(context)!.list_ban,
                color: Colors.orange[400]!,
                onTap: () {},
              ),
              sizedBox12,
              FeatureSetting(
                icon: Icons.logout,
                title: AppLocalizations.of(context)!.logout,
                color: Colors.pink[400]!,
                onTap: () =>
                    context.read<AuthenticationBloc>().add(LogoutEvent()),
              ),
              sizedBox24
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInformation(BuildContext context) {
    return Column(
      children: [
        const UserAvatar(),
        SizedBox(height: 12.h),
        Text(
          userProfile.profile!.fullName,
          maxLines: 4,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontSize: 20.h),
        ),
      ],
    );
  }
}
