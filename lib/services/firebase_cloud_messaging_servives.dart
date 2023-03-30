import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/services/api_service.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMHanlder {
  final NotificationService notificationService;
  final String deviceToken;
  FCMHanlder({required this.notificationService, required this.deviceToken});

  static Future<void> sendMessage({
    required Profile friendProfile,
    required Profile userProfile,
    required String message,
    required String conversationID,
  }) async {
    final headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': APIKey.cloudMessagingServer,
    };
    final dataBody = {
      "notification": {"title": userProfile.fullName, "body": message},
      "priority": "high",
      "data": {
        ConversationsField.conversationID: conversationID,
        ProfileField.senderID: userProfile.id ?? ''
      },
      "to": friendProfile.messagingToken!
    };

    try {
      await ApiServicesImpl().post(
        url: BaseUrl.fcmSend,
        dataBody: dataBody,
        headers: headers,
      );
    } catch (e) {
      log('🚀FCMHanlder - sendMessage⚡ ERROR \n ${e.toString()}');
      rethrow;
    }
  }

  handleFirebaseMessagingStates(BuildContext context) {
    notificationService.initNotification(context: context);
    FirebaseMessaging.instance.getInitialMessage().then(_getInitialMessage);
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  _onMessage(RemoteMessage message) async {
    log("onMessage");

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

  _onMessageOpenedApp(RemoteMessage message) {
    log("onMessOpened");

    notificationService.onNotificationClick.sink.add(message.data);
  }

  _getInitialMessage(RemoteMessage? message) {
    if (message != null) {
      log("initMes");
      notificationService.onNotificationClick.sink.add(message.data);
    }
  }
}
