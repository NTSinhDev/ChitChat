import 'package:chat_app/presentation/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.openSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ), //*
    displayMedium: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ), //*

    titleMedium: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ), //*
    titleSmall: GoogleFonts.openSans(
      fontSize: 15,
      color: lightGreyDarkMode,
      fontWeight: FontWeight.w600,
    ), //*

    bodyLarge: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ), //*
    bodyMedium: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ), 
    bodySmall: GoogleFonts.openSans(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ), //*

    labelLarge: GoogleFonts.openSans(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: lightGreyDarkMode,
    ), //*
    labelSmall: GoogleFonts.openSans(
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ), //*
    headlineMedium: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineSmall: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: lightGreyDarkMode,
    ), //*
    titleLarge: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ), //*
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.openSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ), //*
    displayMedium: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ), //*

    titleMedium: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ), //*
    titleSmall: GoogleFonts.openSans(
      fontSize: 15,
      color: lightGreyDarkMode,
      fontWeight: FontWeight.w600,
    ), //*

    bodyLarge: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ), //*
    bodyMedium: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ), //*
    bodySmall: GoogleFonts.openSans(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ), //*

    labelLarge: GoogleFonts.openSans(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: lightGreyDarkMode,
    ), //*
    labelSmall: GoogleFonts.openSans(
      fontSize: 10.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ), //*
    headlineMedium: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: lightGreyDarkMode,
    ), //*
    titleLarge: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ), //*
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return Colors.black;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedItemColor: lightGreyDarkMode,
      ),
      fontFamily: 'openSans',
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedLabelStyle: TextStyle(fontSize: 14),
        selectedItemColor: Colors.blue,
      ),
      fontFamily: 'openSans',
      textTheme: darkTextTheme,
    );
  }
}
