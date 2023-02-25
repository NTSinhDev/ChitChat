import 'package:chat_app/features/authentication/domain/usecases/usecases.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/app_authentication.dart';
import 'package:chat_app/core/res/theme.dart';
import 'package:chat_app/presentation/services/providers/language_provider.dart';
import 'package:chat_app/presentation/services/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/services/app_state_provider/app_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late String _userID;

  @override
  void initState() {
    _userID = GetUIDAtLocalStorage(sharedPref: sharedPref).userID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _initProviders(),
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
              userIDAtLocalStorage: _userID,
              deviceToken: widget.deviceToken ?? '',
            ),
          );
        },
      ),
    );
  }

  List<SingleChildWidget> _initProviders() {
    return [
      ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ChangeNotifierProvider(
          create: (_) => ThemeProvider(widget.sharedPreferences)),
      ChangeNotifierProvider(
          create: (_) => LanguageProvider(widget.sharedPreferences)),
    ];
  }
}
