import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

extension Localization on BuildContext {
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
  AppLocalizations get languagesExtension => AppLocalizations.of(this)!;
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;
  initScreenUtilDependency() => ScreenUtil.init(
        this,
        designSize: Size(
          MediaQuery.of(this).size.width,
          MediaQuery.of(this).size.height,
        ),
      );
}

extension E on String {
  String get lastCharacters => substring(length - 1);
}
