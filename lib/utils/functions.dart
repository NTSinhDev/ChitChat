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
    // showToast(e.toString());
  }
}


/// Return hh:mm
String formatTime(String time) {
  final checkArrayTime = time.split("/");
  final checkArrayDate = checkArrayTime[0].split(" ");
  return checkArrayDate[0];
}

