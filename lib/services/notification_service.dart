import 'dart:convert';

import 'package:chat_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  final onNotificationClick = ReplaySubject<Map<String, dynamic>?>();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initNotification({required BuildContext context}) async {
    const androidInitializationSettings =
        AndroidInitializationSettings(NotificationsConstantData.defaultIcon);
    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      onDidReceiveNotificationResponse(details, context);
    });
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String urlImage = "",
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      payload: payload,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationsConstantData.channelId,
          NotificationsConstantData.channelName,
          importance: Importance.max,
          priority: Priority.max,
          largeIcon: urlImage.isEmpty ? null : FilePathAndroidBitmap(urlImage),
          channelDescription: NotificationsConstantData.channelDescription,
        ),
        iOS: const DarwinNotificationDetails(
          sound: NotificationsConstantData.sound,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse details,
    BuildContext context,
  ) {
    if (details.payload != null && details.payload!.isNotEmpty) {
      onNotificationClick.sink.add(jsonDecode(details.payload!));
    }
  }
}
