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
import 'package:chat_app/utils/injector.dart';
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
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(userProfile),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.languagesExtension.personal,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spaces.h12,
              _buildUserInformation(context),
              Spaces.h24,
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Divider(thickness: 1.2),
              ),
              Spaces.h24,
              _buildSettingOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOptions(BuildContext context) {
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
            // color: Colors.blue[100],
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(32.h),
            //   topRight: Radius.circular(32.h),
            // ),
            ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChangeDarkmodeFeature(
                userID: userProfile.profile!.id!,
              ),
              Spaces.h12,
              const ChangeLanguageFeature(),
              Spaces.h12,
              FeatureSetting(
                icon: CupertinoIcons.person_circle,
                title: context.languagesExtension.personal_info,
                // color: Colors.deepPurple[400]!,
                onTap: () {
                  FlashMessage(
                    context: context,
                    message: "Đây là nội dung thông báo",
                    type: FlashMessageType.error,
                  );
                },
              ),
              Spaces.h12,
              FeatureSetting(
                icon: Icons.error_outline,
                title: context.languagesExtension.list_ban,
                // color: Colors.orange[400]!,
                onTap: () {},
              ),
              Spaces.h12,
              FeatureSetting(
                icon: Icons.logout,
                title: context.languagesExtension.logout,
                // color: Colors.pink[400]!,
                onTap: () =>
                    context.read<AuthenticationBloc>().add(LogoutEvent()),
              ),
              Spaces.h24,
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
        Spaces.h12,
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
