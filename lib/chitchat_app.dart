import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app/data/repositories/authentication_repository.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/home/home_screen.dart';
import 'package:chat_app/views/injector.dart';

class ChitChatApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  late final FCMHanlder fcmHanlder;
  late final String? userID;
  ChitChatApp({
    super.key,
    required String? token,
    required this.sharedPreferences,
  }) {
    final repository = AuthenticationRepositoryImpl(sharedPreferences);
    userID = repository.getUIDAtLocalStorage();
    fcmHanlder = FCMHanlder(
      notificationService: NotificationService(),
      deviceToken: token ?? '',
    );
  }

  @override
  State<ChitChatApp> createState() => _ChitChatAppState();
}

class _ChitChatAppState extends State<ChitChatApp> {
  bool beInitializedData = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: injectProviders(sharedPreferences: widget.sharedPreferences),
      child: Consumer3<ThemeProvider, LanguageProvider, RouterProvider>(
        builder: (context, theme, language, router, child) {
          return BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              widget.sharedPreferences,
            )..add(widget.userID != null
                ? CheckAuthenticationEvent(userID: widget.userID!)
                : InitLoginEvent()),
            child: MaterialApp(
              navigatorKey: router.navigatorKey,
              title: appName,
              themeMode: theme.themeMode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              locale: language.locale,
              localizationsDelegates: context.localizationsDelegates,
              supportedLocales: context.supportedLocales,
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (!beInitializedData) {
                    context.initScreenUtilDependency();
                    widget.fcmHanlder.handleFirebaseMessagingStates(context);
                    beInitializedData = true;
                  }
                  if (state is RegisterState) return const SignUpScreen();
                  if (state is LoggedState) {
                    return HomeScreen(fcmHanlder: widget.fcmHanlder);
                  }
                  return const LoginScreen();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
