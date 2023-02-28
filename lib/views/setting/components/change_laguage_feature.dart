import 'package:chat_app/core/res/images_animations.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/views/setting/components/feature_setting.dart';
import 'package:chat_app/views/setting/components/setting_bottom_sheet.dart';
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

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bContext) {
        final btmSheetItem1 = _createSettingBottomSheetItem(
          context: bContext,
          lang: langProvider,
          locale: 'vi_VN',
          code: 'vi',
          img: ImgAnmConstants.iVietnam,
          title: AppLocalizations.of(context)!.viet_nam,
        );

        final btmSheetItem2 = _createSettingBottomSheetItem(
          context: bContext,
          lang: langProvider,
          locale: 'en_US',
          code: 'en',
          img: ImgAnmConstants.iEnglish,
          title: AppLocalizations.of(context)!.english,
        );

        return SettingBtmSheet(
          btmSheetTitle: AppLocalizations.of(bContext)!.change_language,
          btmSheetItems: [btmSheetItem1, btmSheetItem2],
        );
      },
    );
  }

  SettingBottomSheetItem _createSettingBottomSheetItem({
    required BuildContext context,
    required LanguageProvider lang,
    required String locale,
    required String code,
    required String img,
    required String title,
  }) =>
      SettingBottomSheetItem(
        leading: SizedBox(
          width: 28.w,
          child: Image.asset(img, fit: BoxFit.fitWidth),
        ),
        title: title,
        ontap: () => lang.toggleLocale(language: locale),
        trailing: lang.locale.languageCode == code
            ? const Icon(
                CupertinoIcons.check_mark_circled,
                color: Colors.blue,
              )
            : null,
      );
}
