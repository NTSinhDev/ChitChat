import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/models/injector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

enum ParsedTo { profile, conversation, message }

class ParsedSnapshotData {
  final ParsedTo parsedTo;
  ParsedSnapshotData({required this.parsedTo});

  dynamic parsed({required Object? data, required String id}) {
    final encodeData = json.encode(data);
    final convertToMap = json.decode(encodeData) as Map<String, dynamic>;
    switch (parsedTo) {
      case ParsedTo.profile:
        return Profile.fromMap(convertToMap, id);
      case ParsedTo.message:
        return Message.fromMap(convertToMap, id);
      default:
        return Conversation.fromMap(convertToMap, id);
    }
  }
}

// /// This function to sort list user by online state
// List<dynamic> sortListUserToOnlState(List<dynamic> listUser) {
//   listUser.sort((previous, next) {
//     final nextRoom = UserPresence.fromJson(next['presence']);
//     if (nextRoom.presence!) {
//       return 1;
//     }
//     return -1;
//   });
//   return listUser;
// }

// /// This function to sort list room by lastest time
// List<dynamic> sortListRoomToLastestTime(List<dynamic> listRoom) {
//   listRoom.sort((previous, next) {
//     final prevRoom = ChatRoom.fromJson(previous['room']);
//     final nextRoom = ChatRoom.fromJson(next['room']);

//     final prevTime = DateFormat(dateMsg).parse(prevRoom.lastMessage!.time);
//     final nextTime = DateFormat(dateMsg).parse(nextRoom.lastMessage!.time);

//     return nextTime.compareTo(prevTime);
//   });
//   return listRoom;
// }

firebaseMsgOnMessage(RemoteMessage message) async {
  await notificationService.showNotification(
    id: 1,
    title: message.notification?.title ?? "",
    body: message.notification?.body ?? "",
    urlImage: "",
    payload: jsonEncode(message.data),
  );

  if (message.notification != null) {
    log('Message also contained a notification: ${message.notification}');
  }
}

/// This function to handle Notification when app on background
Future<void> firebaseOnBackgroundMessageHandle(RemoteMessage mesage) async {
  try {
    log("firebase message title: ${mesage.notification!.title}");
    log("firebase message body: ${mesage.notification!.body}");
  } catch (e) {
    showToast(e.toString());
  }
}

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    fontSize: 12,
    textColor: Colors.black,
    backgroundColor: ResColors.lightGrey(isDarkmode: true),
  );
}

/// format duration to hh:mm:ss
String formatDuration(Duration d) {
  return d.toString().split('.').first.substring(2);
}

/// Return last word of the name
String formatName({required String name}) {
  //Tr?????ng Sinh Nguy???n
  final arrayName = name.split(" "); // Tr?????ng || Sinh || Nguy???n
  if (arrayName.length > 1) {
    // true
    // "Sinh Nguy???n"
    return "${arrayName[0]} ${arrayName[1]}";
  }
  return arrayName[0];
}

/// format time from '12:00 01/10/2000' to date: 01/10 (if month equal now), month: 01/2000 (if year equal now), hour: 12:00 (if date equal now)
String formatTimeRoom(String time) {
  final currentTime = DateFormat('kk:mm dd/MM/yyyy').format(DateTime.now());

  final checkArrayTime = time.split("/");
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

/// Return hh:mm
String formatTime(String time) {
  final checkArrayTime = time.split("/");
  final checkArrayDate = checkArrayTime[0].split(" ");
  return checkArrayDate[0];
}

/// Return dd/mm
String formatDay(String time) {
  final currentTime = DateFormat('kk:mm dd/MM/yyyy').format(DateTime.now());

  final checkArrayTime = time.split("/"); // 10:30 24, 10, 2022
  final currentArrayTime = currentTime.split('/');

  final checkYear = int.parse(checkArrayTime[2]);
  final currentYear = int.parse(currentArrayTime[2]);

  final checkMonth = int.parse(checkArrayTime[1]);
  final currentMonth = int.parse(currentArrayTime[1]);

  final checkArrayDate = checkArrayTime[0].split(" ");
  final currentArrayDate = currentArrayTime[0].split(" ");
  final checkDate = int.parse(checkArrayDate[1]);
  final currentDate = int.parse(currentArrayDate[1]);

  if (checkYear < currentYear) {
    return "$checkDate/$checkMonth/$checkYear";
  }

  if (checkMonth < currentMonth) {
    return customTimeResult(checkMonth, currentMonth, "th??ng tr?????c");
  }

  if (checkDate < currentDate) {
    return customTimeResult(checkDate, currentDate, "ng??y tr?????c");
  }

  final checkArrayHour = checkArrayDate[0].split(":"); // hh, min
  final currentArrayHour = currentArrayDate[0].split(":");
  final checkHour = int.parse(checkArrayHour[0]);
  final checkMin = int.parse(checkArrayHour[1]);
  final currentHour = int.parse(currentArrayHour[0]);
  final currentMin = int.parse(currentArrayHour[1]);

  if (checkHour < currentHour) {
    return customTimeResult(checkHour, currentHour, "gi??? tr?????c");
  }

  if (checkMin < currentMin) {
    return customTimeResult(checkMin, currentMin, "ph??t tr?????c");
  }
  return "v??i gi??y tr?????c";
}

String customTimeResult(int check, int current, String custom) {
  int result = current - check;
  return "$result $custom";
}
