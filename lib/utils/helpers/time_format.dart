part of 'helpers.dart';

class TimeFormat {
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

  /// format time from '12:00 01/10/2000' to date: 01/10 (if month equal now), month: 01/2000 (if year equal now), hour: 12:00 (if date equal now)
  static String formatTimeRoom(DateTime time) {
    final timeNeedFormat = DateFormat('kk:mm dd/MM/yyyy').format(time);
    final currentTime = DateFormat('kk:mm dd/MM/yyyy').format(DateTime.now());

    final checkArrayTime = timeNeedFormat.split("/");
    final currentArrayTime = currentTime.split('/');

    // Check year
    final checkYear = int.parse(checkArrayTime[2]);
    final currentYear = int.parse(currentArrayTime[2]);

    // Check month
    final checkMonth = int.parse(checkArrayTime[1]);
    final currentMonth = int.parse(currentArrayTime[1]);

    if (checkYear < currentYear) {
      return "$checkMonth/$checkYear";
    }

    final checkArrayDate = checkArrayTime[0].split(" ");
    final currentArrayDate = currentArrayTime[0].split(" ");
    // Check date
    final checkDate = int.parse(checkArrayDate[1]);
    final currentDate = int.parse(currentArrayDate[1]);

    if (checkMonth < currentMonth || checkDate < currentDate) {
      return "$checkDate/$checkMonth";
    }
    return checkArrayDate[0];
  }
}
