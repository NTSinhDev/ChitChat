import 'dart:developer';

import 'package:chat_app/chitchat_app.dart';
import 'package:chat_app/services/injector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _sharedPref;
late NotificationService _notificationService;
late String? _deviceToken;
late FCMHanlder _fcmHanlder;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  _sharedPref = await SharedPreferences.getInstance();
  _notificationService = NotificationService();
  _deviceToken = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(onBackground);

  // Change default system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  _fcmHanlder = FCMHanlder(notificationService: _notificationService);
  final app = ChitChatApp(
    sharedPreferences: _sharedPref,
    deviceToken: _deviceToken,
    fcmHanlder: _fcmHanlder,
    notificationService: _notificationService,
  );
  runApp(app);
}

Future<void> onBackground(RemoteMessage mesage) async {
  try {
    log("firebase message title: ${mesage.notification!.title}");
    log("firebase message body: ${mesage.notification!.body}");
  } catch (e) {
    // showToast(e.toString());
    log('🚀firebaseOnBackgroundMessageHandle⚡\n${e.toString()}');
  }
}


