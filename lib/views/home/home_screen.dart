import 'package:chat_app/data/datasources/remote_datasources/key_remote_datesource.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/ask_ai_button.dart';

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
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    KeyRemoteDataSourceImpl().getAPIKey();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final routerProvider = context.watch<RouterProvider>();

    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 68.h,
          backgroundColor: ResColors.purpleMessage(theme: theme),
          title: Row(
            children: [
              InkWell(
                onTap: () => navigateToSettingScreen(context),
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: StateAvatar(
                      urlImage: widget.userProfile.urlImage,
                      userId: '',
                      radius: 44.r,
                    ),
                  ),
                ),
              ),
              Text(
                context.languagesExtension.chats,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        body: BlocProvider<ConversationBloc>(
          create: (_) => ConversationBloc(
            currentUser: widget.userProfile,
            fcmHanlder: widget.fcmHanlder,
            routerProvider: routerProvider,
          )..add(ListenConversationsEvent()),
          child: const SafeArea(child: ConversationScreen()),
        ),
        floatingActionButton: AskAIButton(
          userProfile: widget.userProfile,
          isZoomOut: true,
        ),
      ),
    );
  }

  navigateToSettingScreen(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingScreen(
            userProfile: widget.userProfile,
          ),
        ),
      );

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
