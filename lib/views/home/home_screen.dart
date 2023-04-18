import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/conversations/components/search_bar.dart';
import 'package:chat_app/views/home/components/init_state_managers.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/models/injector.dart';
import 'package:provider/provider.dart';
import 'components/ask_ai_button.dart';

part 'components/home_screen_app_bar.dart';

class HomeScreen extends StatefulWidget {
  final FCMHanlder fcmHanlder;
  const HomeScreen({super.key, required this.fcmHanlder});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthenticationBloc>().userProfile!;
    return InitializeStateManagers(
      fcmHanlder: widget.fcmHanlder,
      child: WillPopScope(
        onWillPop: exitApp,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              _homeScreenAppBar(
                context: context,
                urlImage: currentUser.urlImage,
                openSetting: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(
                        userProfile: currentUser,
                      ),
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: ConversationScreen(fcmHanlder: widget.fcmHanlder),
              ),
            ],
          ),
          floatingActionButton: AskAIButton(userProfile: currentUser),
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
