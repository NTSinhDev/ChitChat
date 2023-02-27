import 'package:chat_app/view_model/blocs/authentication/authentication_bloc.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeLanguageFeature extends StatelessWidget {
  const ChangeLanguageFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureSetting(
      icon: CupertinoIcons.textformat,
      title: AppLocalizations.of(context)!.language,
      color: Colors.green[400]!,
      onTap: () => _changeLanguage(context),
    );
  }

  _changeLanguage(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final userID = Provider.of<AuthenticationBloc>(context, listen: false)
            .userProfile
            ?.profile
            ?.id ??
        '';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 180.h,
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 20.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.h),
              topRight: Radius.circular(12.h),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.change_language,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 8.h),
                ListTile(
                  onTap: () => _changeLocale(context, 'vi_VN', langProvider),
                  leading: SizedBox(
                    width: 28.w,
                    child: Image.asset(
                      "assets/logos/vietname_icon.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.viet_nam,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                  trailing: langProvider.locale.languageCode == 'vi'
                      ? const Icon(
                          CupertinoIcons.check_mark_circled,
                          color: Colors.blue,
                        )
                      : null,
                ),
                ListTile(
                    onTap: () => _changeLocale(context, 'en_US', langProvider),
                    leading: SizedBox(
                      width: 28.w,
                      child: Image.asset(
                        "assets/logos/english_icon.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.english,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    trailing: langProvider.locale.languageCode == 'en'
                        ? const Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Colors.blue,
                          )
                        : null),
              ],
            ),
          ),
        );
      },
    );
  }

  _changeLocale(BuildContext context, String locale, LanguageProvider lang) {
    lang.toggleLocale(language: locale);
  }
}
