import 'dart:developer';

import 'package:chat_app/utils/injector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtilities {
  static String formatTime(DateTime time, Locale local) {
    final now = DateTime.now();
    if (time.year < now.year) return "${time.day}/${time.month}/${time.year}}";
    if (time.month < now.month ||
        !_HandleTools.isDateInCurrentWeek(date: time)) {
      return _HandleTools.formatMonthTimeByLangugageCode(
        code: local.languageCode,
        time: time,
      );
    }
    if (_HandleTools.isDateInCurrentWeek(date: time) && time.day != now.day) {
      return _HandleTools.formatDayTimeByLangugageCode(
        code: local.languageCode,
        time: time,
      );
    }
    return DateFormat('kk:mm').format(time);
  }

  static String differenceTime({
    required BuildContext context,
    required DateTime earlier,
  }) {
    DateTime later = DateTime.now();
    if (later.difference(earlier).inHours >= 0 &&
        later.difference(earlier).inHours < 24) {
      if (later.difference(earlier).inMinutes >= 0 &&
          later.difference(earlier).inMinutes < 1) {
        return "${later.difference(earlier).inSeconds} ${context.languagesExtension.seconds}";
      } else if (later.difference(earlier).inMinutes >= 1 &&
          later.difference(earlier).inMinutes < 60) {
        return "${later.difference(earlier).inMinutes} ${context.languagesExtension.minutes}";
      } else if (later.difference(earlier).inMinutes >= 60) {
        return "${later.difference(earlier).inHours} ${context.languagesExtension.hours}";
      }
    } else if (later.difference(earlier).inHours >= 24 &&
        later.difference(earlier).inHours < 720) {
      return "${later.difference(earlier).inDays} ${context.languagesExtension.days}";
    } else {
      int month = 1;
      month = (month * later.difference(earlier).inDays / 30).round();
      return "$month ${context.languagesExtension.months}";
    }
    return '';
  }
}

class _HandleTools {
  static bool isDateInCurrentWeek({required DateTime date}) {
    List<DateTime> currentWeek = _getCurrentWeek();
    bool isDateInWeek = currentWeek.any((day) =>
        day.year == date.year &&
        day.month == date.month &&
        day.day == date.day);
    return isDateInWeek;
  }

  static String formatDayTimeByLangugageCode({
    required String code,
    required DateTime time,
  }) {
    final day = DateFormat('EEE').format(time);
    return code == 'vi' ? _getDayByVietnamese(day: day) : day;
  }

  static String _getDayByVietnamese({required String day}) {
    switch (day) {
      case 'Mon':
        return 'T2';
      case 'Tue':
        return 'T3';
      case 'Wed':
        return 'T4';
      case 'Thurs':
        return 'T5';
      case 'Fri':
        return 'T6';
      case 'Sat':
        return 'T7';
      case 'Sun':
        return 'CN';
      default:
        log('🚀_getDayByVietnamese⚡ $day');
        return 'Error';
    }
  }

  static String formatMonthTimeByLangugageCode({
    required String code,
    required DateTime time,
  }) =>
      code == "vi"
          ? "${time.day} thg ${time.month}"
          : '${DateFormat('MMM').format(time)} ${_getDayByEnglish(day: time.day)}';

  static String _getDayByEnglish({required int day}) {
    final dayLastLetter = "$day".lastCharacters;
    switch (dayLastLetter) {
      case '1':
        return "${day}st";
      case '2':
        return "${day}nd";
      case '3':
        return "${day}rd";
      default:
        return "${day}th";
    }
  }

  static List<DateTime> _getCurrentWeek() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: dayOfWeek - 1));
    List<DateTime> daysOfWeek = [];
    for (int i = 0; i < 7; i++) {
      daysOfWeek.add(startOfWeek.add(Duration(days: i)));
    }
    return daysOfWeek;
  }
}
