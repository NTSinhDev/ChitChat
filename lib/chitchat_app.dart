import 'dart:developer';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/data/repositories/authentication_repository.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/home/home_screen.dart';
import 'package:chat_app/views/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChitChatApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  late final FCMHanlder fcmHanlder;
  ChitChatApp({
    super.key,
    required this.sharedPreferences,
    required String? token,
  }) {
    fcmHanlder = FCMHanlder(
      notificationService: NotificationService(),
      deviceToken: token ?? '',
    );

    logToken();
  }

  logToken() {
    log('🚀log⚡ ${fcmHanlder.deviceToken}');
  }

  @override
  State<ChitChatApp> createState() => _ChitChatAppState();
}

class _ChitChatAppState extends State<ChitChatApp> {
  late String? userID;

  @override
  void initState() {
    getUIDAtLocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: injectProviders(sharedPreferences: widget.sharedPreferences),
      child: Consumer3<ThemeProvider, LanguageProvider, RouterProvider>(
        builder: (context, theme, language, router, child) {
          return BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              widget.sharedPreferences,
            )..add(userID != null
                ? CheckAuthenticationEvent(userID: userID!)
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
                  context.initScreenUtilDependency();
                  widget.fcmHanlder.handleFirebaseMessagingStates(context);

                  if (state is RegisterState) {
                    return const SignUpScreen();
                  }
                  if (state is LoggedState) {
                    return HomeScreen(
                      fcmHanlder: widget.fcmHanlder,
                    );
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

  getUIDAtLocalStorage() {
    final AuthenticationRepository repository = AuthenticationRepositoryImpl(
      widget.sharedPreferences,
    );
    userID = repository.getUIDAtLocalStorage();
  }
}
