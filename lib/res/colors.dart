import 'package:flutter/material.dart';

class ResColors {
  static final mdblack = Colors.grey[900];
  static final lmlightGrey100 = Colors.grey.shade100;

  static const darkPurple = Color.fromARGB(255, 91, 33, 192);
  static const deepPurple = Colors.deepPurple;
  static const deepPurpleAccent = Colors.deepPurpleAccent;
  static const customPurple = Color.fromARGB(255, 114, 36, 249);
  static const redAccent = Colors.redAccent;

  static Color appColor({required bool isDarkmode}) {
    return isDarkmode ? const Color(0xfafafafa) : const Color(0xFF303030);
  }

  static Color blue({required bool isDarkmode}) {
    return isDarkmode ? const Color(0xFF0260AE) : Colors.blue;
  }

  static Color lightGrey({required bool isDarkmode}) {
    return isDarkmode ? Colors.grey : Colors.grey.shade200;
  }

  static Color darkGrey({required bool isDarkmode}) {
    return isDarkmode ? Colors.grey[800]! : Colors.grey;
  }
}
