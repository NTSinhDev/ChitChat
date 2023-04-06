import 'package:flutter/material.dart';

class ResColors {
  static final mdblack = Colors.grey[900];
  static final lmlightGrey100 = Colors.grey.shade100;

  static const darkPurple = Color.fromARGB(255, 91, 33, 192);
  static const deepPurple = Colors.deepPurple;
  static const deepPurpleAccent = Colors.deepPurpleAccent;
  static const customPurple = Color.fromARGB(255, 114, 36, 249);
  static const redAccent = Colors.redAccent;

  static const customNewVeryDarkPurple = Color(0xff4f3cc9);
  static const customNewDarkPurple = Color(0xff6a4997);
  static const customNewLightPurple = Color(0xffa682df);
  static const customNewMediumPurple = Color(0xffa684dd);
  static const backgroundLightPurple = Color(0xfff2eaff);

  static const sunshine = [
    Color(0xff75AAF0),
    Color(0xff7BC1FA),
    // crayolaLemonYellow,
    bananaYellow,
    // ripeMango,
    // deepSaffron,
    // princetonOrange,
  ];
  static const crayolaLemonYellow = Color(0xffFDE659);
  static const bananaYellow = Color(0xffFFE134);
  static const ripeMango = Color(0xffFFBF2E);
  static const deepSaffron = Color(0xffFF9E28);
  static const princetonOrange = Color(0xffFE7C22);

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

  static Color purpleMessage({required bool theme}) =>
      theme ? ResColors.darkPurple : ResColors.deepPurpleAccent;

  static Color customNewPurple({required bool isDarkmode}) {
    return isDarkmode
        ? ResColors.customNewDarkPurple
        : ResColors.customNewLightPurple;
  }
}
