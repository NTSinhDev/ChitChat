import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/services/injector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHanlder {
  final NotificationService notificationService;
  FCMHanlder({required this.notificationService});

  onMessage(RemoteMessage message) async {
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

  
}
