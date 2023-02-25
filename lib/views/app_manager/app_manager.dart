import 'package:chat_app/models/profile.dart';
import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/view_model/providers/app_state_provider.dart';
import 'package:chat_app/views/calling/calling_screen.dart';
import 'package:chat_app/views/groups/group_chat.dart';
import 'package:chat_app/views/home/home_screen.dart';
import 'package:chat_app/views/setting/setting_screen.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/widgets/app_bar_page_managar.dart';
import 'package:chat_app/widgets/state_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppManager extends StatefulWidget {
  final Profile profile;
  const AppManager({super.key, required this.profile});

  @override
  State<AppManager> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  DateTime timeBackPressed = DateTime.now();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> titlesPage = [
      AppLocalizations.of(context)!.chats,
      AppLocalizations.of(context)!.groups,
      AppLocalizations.of(context)!.calls,
      AppLocalizations.of(context)!.personal,
    ];

    final List<Widget> pages = [
      HomeScreen(),
      const GroupChatScreen(),
      const CallingScreen(),
      SettingScreen(
        profile: widget.profile,
      )
    ];
    List<dynamic>? valueRequest = context.watch<ChatBloc>().requests;
    bool theme = context.watch<AppStateProvider>().darkMode;
    String urlImage = context.watch<AppStateProvider>().urlImage;

    return WillPopScope(
      onWillPop: () => _exitApp(theme),
      child: Scaffold(
        appBar: appBarPageManagar(
          titlesPage[currentPage],
          context,
          urlImage,
          '',
          valueRequest != null ? valueRequest.length : 0,
          () {
            setState(() {
              currentPage = 3;
            });
          },
        ),
        body: SafeArea(child: pages[currentPage]),
        bottomNavigationBar: SizedBox(
          height: 76.h,
          child: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: (currentIndex) {
              setState(() {
                currentPage = currentIndex;
              });
            },
            selectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            items: [
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: CupertinoIcons.chat_bubble_fill,
                  valueState: '1',
                ),
                label: titlesPage[0],
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: CupertinoIcons.group_solid,
                ),
                label: titlesPage[1],
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: CupertinoIcons.phone_solid,
                ),
                label: titlesPage[2],
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: Icons.settings,
                ),
                label: titlesPage[3],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(bool theme) async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.exit_app,
        fontSize: 10.r,
        textColor: theme ? Colors.white : Colors.black,
        backgroundColor: theme ? darkGreyDarkMode : lightGreyLightMode,
      );
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }
}
