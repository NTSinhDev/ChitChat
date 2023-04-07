import 'dart:developer';

import 'package:chat_app/chitchat_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  log('🚀 Đang khởi tạo WidgetsFlutterBinding, Firebase, Hive, sharedPreferences');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  final sharedPreferences = await SharedPreferences.getInstance();
  final deviceToken = await FirebaseMessaging.instance.getToken();
  log('💯 Đã Khởi tạo xong 🤩');

  FirebaseMessaging.onBackgroundMessage(onBackground);

  // Change default system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  log('🚀 Bắt đầu');
  runApp(ChitChatApp(sharedPreferences: sharedPreferences, token: deviceToken));
}

Future<void> onBackground(RemoteMessage mesage) async {
  try {
    log("firebase message title: ${mesage.notification!.title}");
    log("firebase message body: ${mesage.notification!.body}");
  } catch (e) {
    log('🚀firebaseOnBackgroundMessageHandle⚡\n${e.toString()}');
  }
}
