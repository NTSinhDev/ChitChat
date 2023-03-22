import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/data/repositories/authentication_repository.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/home/home_screen.dart';
import 'package:chat_app/views/injector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/utils/injector.dart';

class ChitChatApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final String? deviceToken;
  const ChitChatApp({
    super.key,
    required this.sharedPreferences,
    this.deviceToken,
  });

  @override
  State<ChitChatApp> createState() => _ChitChatAppState();
}

class _ChitChatAppState extends State<ChitChatApp> {
  late String? _userID;

  @override
  void initState() {
    _getUIDAtLocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: injectProviders(sharedPreferences: widget.sharedPreferences),
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, theme, language, child) {
          return BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              widget.sharedPreferences,
            )..add(_userID != null
                ? CheckAuthenticationEvent(userID: _userID!)
                : InitLoginEvent()),
            child: MaterialApp(
              title: 'ChitChat App',
              debugShowCheckedModeBanner: false,
              themeMode: theme.themeMode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              locale: language.locale,
              localizationsDelegates: context.localizationsDelegates,
              supportedLocales: context.supportedLocales,
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  _initScreenUtilDependency(context);
                  _notificationServices(context);
                  if (state is RegisterState) {
                    return const SignUpScreen();
                  }
                  if (state is LoggedState) {
                    return HomeScreen(userProfile: state.userProfile);
                  }
                  return LoginScreen(deviceToken: widget.deviceToken!);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _initScreenUtilDependency(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
    );
  }

  _notificationServices(BuildContext context) {
    notificationService.initNotification(context: context);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          Navigator.of(context).pushNamed('/app');

          showToast('đã push name');
        }
      },
    );

    FirebaseMessaging.onMessage.listen(firebaseMsgOnMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        Navigator.of(context).pushNamed('/app');
      },
    );
  }

  _getUIDAtLocalStorage() {
    final AuthenticationRepository repository = AuthenticationRepositoryImpl(
      widget.sharedPreferences,
    );
    _userID = repository.getUIDAtLocalStorage();
  }
}
