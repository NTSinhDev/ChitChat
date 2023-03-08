import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  final SharedPreferences sharedPref;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeProvider(this.sharedPref) {
    final themeSharedPref = sharedPref.getBool(StorageKey.sTheme);
    if (themeSharedPref != null) {
      themeMode = themeSharedPref ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.light;
    }
  }

  Future<void> toggleTheme({required bool isOn, required String userID}) async {
    if (userID.isEmpty) return;
    final response = await sharedPref.setBool(StorageKey.sTheme, isOn);
    if (response) {
      themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  setThemeData({required bool? isDarkMode}) {
    if (isDarkMode != null) {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
