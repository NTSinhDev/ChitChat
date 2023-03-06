import 'package:chat_app/res/enum/enums.dart';
import 'package:chat_app/res/helpers/notify/flash_message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/views/search/search_screen.dart';
import 'package:chat_app/views/setting/setting_screen.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chat_app/views/app_manager/components/state_bottom_navigation_bar.dart';

class AppManager extends StatefulWidget {
  final UserProfile userProfile;
  const AppManager({super.key, required this.userProfile});

  @override
  State<AppManager> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  DateTime timeBackPressed = DateTime.now();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<String> titlesPage = [
      AppLocalizations.of(context)!.chats,
      AppLocalizations.of(context)!.groups,
      AppLocalizations.of(context)!.calls,
      AppLocalizations.of(context)!.personal,
    ];
    List<Widget> pages = [
      // const SearchScreen(),
      Container(),
      Container(),
      SettingScreen(
        userProfile: widget.userProfile,
      )
    ];

    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 3;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: StateAvatar(
                      urlImage: widget.userProfile.urlImage,
                      isStatus: false,
                      radius: 40.r,
                    ),
                  ),
                ),
              ),
              Text(
                titlesPage[currentPage],
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
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
                    icon: CupertinoIcons.chat_bubble_fill),
                label: AppLocalizations.of(context)!.chats,
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: CupertinoIcons.group_solid,
                ),
                label: AppLocalizations.of(context)!.groups,
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(
                  icon: CupertinoIcons.phone_solid,
                ),
                label: AppLocalizations.of(context)!.calls,
              ),
              BottomNavigationBarItem(
                icon: const StateBottomNavigationBar(icon: Icons.settings),
                label: AppLocalizations.of(context)!.personal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
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
