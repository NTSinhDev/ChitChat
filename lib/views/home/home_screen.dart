import 'dart:math';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/admin/admin_screen.dart';

import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/ask_ai_button.dart';

part 'components/app_bar.dart';

class HomeScreen extends StatefulWidget {
  final FCMHanlder fcmHanlder;
  const HomeScreen({
    super.key,
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
    final userProfile = context.watch<AuthenticationBloc>().userProfile!;
    final routerProvider = context.watch<RouterProvider>();

    return WillPopScope(
      onWillPop: exitApp,
      child: Stack(
        children: [
          const SettingScreen(),
          TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0,
              end: endTweenValue,
            ),
            duration: const Duration(milliseconds: 100),
            builder: (context, value, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 250 * value)
                  ..rotateY((pi / 6) * value),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      endTweenValue == 0 ? endTweenValue : 24,
                    ),
                    bottomLeft: Radius.circular(
                      endTweenValue == 0 ? endTweenValue : 24,
                    ),
                  ),
                  child: Scaffold(
                    appBar: _homeScreenAppBar(
                      context: context,
                      theme: theme,
                      openSetting: () {
                        setState(() {
                          endTweenValue == 0
                              ? endTweenValue = 1
                              : endTweenValue = 0;
                          isGestureActive = true;
                        });
                      },
                    ),
                    body: BlocProvider<ConversationBloc>(
                      create: (_) => ConversationBloc(
                        currentUser: userProfile,
                        fcmHanlder: widget.fcmHanlder,
                        routerProvider: routerProvider,
                      )..add(ListenConversationsEvent()),
                      child: const ConversationScreen(),
                    ),
                    floatingActionButton: AskAIButton(
                      userProfile: userProfile,
                      isZoomOut: true,
                    ),
                  ),
                ),
              );
            },
          ),
          if (isGestureActive)
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  endTweenValue = 0;
                  isGestureActive = false;
                });
              },
            )
        ],
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
