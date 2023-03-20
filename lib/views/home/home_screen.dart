import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/ask_chitchat/ask_chitchat_screen.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;
  const HomeScreen({super.key, required this.userProfile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPressed = DateTime.now();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(
                        userProfile: widget.userProfile,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: StateAvatar(
                      urlImage: widget.userProfile.urlImage,
                      userId: '',
                      radius: 40.r,
                    ),
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.chats,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<SearchBloc>(
                    create: (context) => SearchBloc(
                      currentUser: widget.userProfile,
                    ),
                    child: SearchScreen(
                      currentUser: widget.userProfile,
                    ),
                  ),
                ),
              ),
              child: const Text("Go To Search Screen"),
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: 140.w,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AskChitChatcreen(
                    userProfile: widget.userProfile,
                  ),
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48.r),
                bottomRight: const Radius.circular(0),
                topLeft: Radius.circular(48.r),
                topRight: Radius.circular(48.r),
              ),
            ),
            backgroundColor:
                theme ? ResColors.darkPurple : ResColors.deepPurpleAccent,
            child: Text(
              AppLocalizations.of(context)!.ask_ChitChat,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white, fontSize: 13.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);
    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      FlashMessage(
        context: context,
        message: AppLocalizations.of(context)!.exit_app,
        type: FlashMessageType.info,
      );
      return false;
    } else {
      return true;
    }
  }
}
