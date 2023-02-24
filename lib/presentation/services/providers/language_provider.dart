import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale locale;
  final SharedPreferences sharedPref;

  LanguageProvider(this.sharedPref) {
    _initLocale();
  }

  Future toggleLocale(
      {required String language, required String userID}) async {
    final value = await sharedPref.setString('language', language);
    if (value) {
      _setLocale(language: language);
    }
  }

  _setLocale({required String language}) {
    final splitLanguage = language.split("_");
    locale = Locale(
      splitLanguage[0],
      splitLanguage[1],
    );
    notifyListeners();
  }

  _initLocale() {
    final language = sharedPref.getString('language');
    if (language == null || language == "") {
      return locale = const Locale("vi", "VN");
    }

    final splitLanguage = language.split("_");
    locale = Locale(
      splitLanguage[0],
      splitLanguage[1],
    );
    notifyListeners();
  }
}
