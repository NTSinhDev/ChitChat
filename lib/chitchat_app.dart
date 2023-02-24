import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/app_authentication.dart';
import 'package:chat_app/presentation/res/theme.dart';
import 'package:chat_app/presentation/services/providers/language_provider.dart';
import 'package:chat_app/presentation/services/providers/theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/services/app_state_provider/app_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChitChatApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const ChitChatApp({super.key, required this.sharedPreferences});

  @override
  State<ChitChatApp> createState() => _ChitChatAppState();
}

class _ChitChatAppState extends State<ChitChatApp> {
  String tokenUser = '';
  String deviceToken = '';

  @override
  void initState() {
    _getToken();
    _getTokenDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(widget.sharedPreferences)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(widget.sharedPreferences)),
      ],
      child: Consumer3<AppStateProvider, ThemeProvider, LanguageProvider>(
        builder: (context, appState, theme, language, child) {
          return MaterialApp(
            title: 'ChitChat App',
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: appState.darkMode ? AppTheme.dark() : AppTheme.light(),
            darkTheme: AppTheme.dark(),
            locale: language.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AppAuthentication(
              sharedPreferences: widget.sharedPreferences,
              // tokenUser: tokenUser,
              deviceToken: deviceToken,
            ),
          );
        },
      ),
    );
  }

  // Get token of device
  _getTokenDevice() {
    FirebaseMessaging firebaseMsging = FirebaseMessaging.instance;
    firebaseMsging.getToken().then((value) {
      if (value == null) return;
      log('🚀log⚡: $value');
      deviceToken = value;
    });
  }

  _getToken() {
    final authToken = sharedPref.getString('auth_token');
    if (authToken == null) return;
    tokenUser = authToken;
  }
}
