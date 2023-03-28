import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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




/// This function to handle Notification when app on background



/// Return hh:mm
String formatTime(String time) {
  final checkArrayTime = time.split("/");
  final checkArrayDate = checkArrayTime[0].split(" ");
  return checkArrayDate[0];
}

