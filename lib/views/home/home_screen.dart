import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chat_app/views/home/components/state_bottom_navigation_bar.dart';

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
    List<String> titlesPage = [
      AppLocalizations.of(context)!.chats,
      AppLocalizations.of(context)!.personal,
    ];
    List<Widget> pages = [
      Center(
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
      SettingScreen(userProfile: widget.userProfile)
    ];

    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    currentPage = 1;
                  });
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
                icon: const StateBottomNavigationBar(icon: Icons.settings),
                label: AppLocalizations.of(context)!.personal,
              ),
            ],
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
