import 'package:chat_app/chitchat_app.dart';
import 'package:chat_app/presentation/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/utils/functions.dart';

late SharedPreferences sharedPref;
late NotificationService notificationService;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Change default system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  // Hide status bar and bottom bar
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.immersiveSticky,
  //   overlays: [SystemUiOverlay.bottom],
  // );

  // Firebase
  await Firebase.initializeApp();
  // Notification
  FirebaseMessaging.onBackgroundMessage(firebaseOnBackgroundMessageHandle);
  notificationService = NotificationService();

  await Hive.initFlutter();
    
  // Local storage
  sharedPref = await SharedPreferences.getInstance();

  runApp(ChitChatApp(sharedPreferences: sharedPref));
}
