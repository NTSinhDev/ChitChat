import 'package:chat_app/chitchat_app.dart';
import 'package:chat_app/presentation/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/functions.dart';

late SharedPreferences sharedPref;
late NotificationService notificationService;
late String? deviceToken;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Change default system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Firebase
  await Firebase.initializeApp();

  // Notification
  FirebaseMessaging.onBackgroundMessage(firebaseOnBackgroundMessageHandle);
  deviceToken = await FirebaseMessaging.instance.getToken();
  notificationService = NotificationService();

  // Local storage
  sharedPref = await SharedPreferences.getInstance();

  runApp(ChitChatApp(sharedPreferences: sharedPref, deviceToken: deviceToken));
}
