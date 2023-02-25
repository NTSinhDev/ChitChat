import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Tại đây, tao sẽ khai báo và khởi tạo một biến themeMode.
  // Mặc định nó sẽ là light. Nó sẽ thay đổi khi người dùng thay đổi chế độ.
  ThemeMode themeMode = ThemeMode.light; // dark || light || system

  // Khi người dùng thay đổi theme, data sẽ lưu ở local chứ ko bỏ vào server nữa.
  // Điều này giúp cải thiện hiệu suất và tiết kiệm tài nguyên.
  final SharedPreferences sharedPref;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeProvider(this.sharedPref) {
    _init();
  }

  Future<void> toggleTheme({required bool isOn, required String userID}) async {
    final response = await sharedPref.setBool('theme', isOn);
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

  _init() {
    final themeSharedPref = sharedPref.getBool('theme');
    if (themeSharedPref != null) {
      themeMode = themeSharedPref ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.light;
    }
  }
}
