import 'package:chat_app/core/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initNotification({required BuildContext context}) async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          onDidReceiveNotificationResponse(
        details,
        context,
      ),
    );
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
          'com.example.eximbank_app',
          'eximbank',
          importance: Importance.max,
          priority: Priority.max,
          largeIcon: urlImage.isEmpty ? null : FilePathAndroidBitmap(urlImage),
          channelDescription: "Main Channel Notifiaction",
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse details, BuildContext context) {
    if (details.payload != null && details.payload!.isNotEmpty) {
      showToast(details.payload!);
    }
  }
}
