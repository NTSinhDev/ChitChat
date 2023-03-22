import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

extension Localization on BuildContext {
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
  AppLocalizations get languagesExtension => AppLocalizations.of(this)!;
}
