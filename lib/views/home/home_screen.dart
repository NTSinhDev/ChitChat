import 'dart:developer';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/models/injector.dart';
import 'components/animate_home_screen.dart';
import 'components/ask_ai_button.dart';

part 'components/app_bar.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;
  final FCMHanlder fcmHanlder;
  const HomeScreen({
    super.key,
    required this.userProfile,
    required this.fcmHanlder,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPressed = DateTime.now();
  double endTweenValue = 0;
  bool isGestureActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final currentUser = context.watch<AuthenticationBloc>().userProfile!;
    final routerProvider = context.watch<RouterProvider>();
    return BlocProvider<ConversationBloc>(
      create: (_) => ConversationBloc(
        currentUser: currentUser,
        fcmHanlder: widget.fcmHanlder,
        routerProvider: routerProvider,
      )
        ..add(ListenConversationsEvent())
        ..add(HandleNotificationServiceEvent(
          context: context,
          navigatorKey: routerProvider.navigatorKey,
        )),
      child: WillPopScope(
        onWillPop: exitApp,
        child: Stack(
          children: [
            SettingScreen(userProfile: widget.userProfile),
            AnimateHomeScreen(
              endTweenValue: endTweenValue,
              appbar: _homeScreenAppBar(
                context: context,
                urlImage: widget.userProfile.urlImage,
                theme: theme,
                openSetting: () {
                  setState(() {
                    endTweenValue == 0 ? endTweenValue = 1 : endTweenValue = 0;
                    isGestureActive = true;
                  });
                },
              ),
              body: ConversationScreen(fcmHanlder: widget.fcmHanlder),
              floatingBtn: AskAIButton(userProfile: widget.userProfile),
            ),
            if (isGestureActive)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final x = details.delta.dx;
                  final xNegative = x * -1;
                  if (details.delta.dx < 0 && xNegative > 4) {
                    log('🚀log⚡ $x && $xNegative');
                    setState(() {
                      endTweenValue = 0;
                      isGestureActive = false;
                    });
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);
    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      FlashMessageWidget(
        context: context,
        message: context.languagesExtension.exit_app,
        type: FlashMessageType.info,
      );
      return false;
    } else {
      return true;
    }
  }
}
