import 'package:chat_app/main.dart';
import 'package:chat_app/views/login/login_screen.dart';
import 'package:chat_app/views/signup/signup_screen.dart';
import 'package:chat_app/view_model/blocs/authentication/bloc_injector.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/helpers/loading/loading_screen.dart';
import 'view_model/providers/app_state_provider.dart';

class AppAuthentication extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final String? userIDAtLocalStorage;
  final String deviceToken;
  const AppAuthentication({
    Key? key,
    required this.sharedPreferences,
    required this.deviceToken,
    required this.userIDAtLocalStorage,
  }) : super(key: key);

  @override
  State<AppAuthentication> createState() => _AppAuthenticationState();
}

class _AppAuthenticationState extends State<AppAuthentication> {
  @override
  void initState() {
    super.initState();
    _notificationServices();
  }

  @override
  Widget build(BuildContext context) {
    _initScreenUtilDependency(context);

    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        widget.sharedPreferences,
      )..add(widget.userIDAtLocalStorage != null
          ? CheckAuthenticationEvent(userID: widget.userIDAtLocalStorage!)
          : InitLoginEvent()),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // Check dark mode
          if (state is LoggedState) {
            // app states
            AppStateProvider appState = context.read<AppStateProvider>();
            // if (state.authUser != null) {
            //   appState.darkMode = state.authUser!.user!.isDarkMode!;
            //   if (state.authUser!.user!.urlImage != null) {
            //     appState.urlImage = state.authUser!.user!.urlImage!;
            //   }
            // }
          }
        },
        builder: (context, state) {
          // Register screen
          if (state is RegisterState) {
            return const SignUpScreen();
          }
          // Home page
          if (state is LoggedState) {
            final name = state.userProfile.profile == null
                ? "Unknowned"
                : state.userProfile.profile!.fullName;
            return Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text(name)),
                    Text(state.userProfile.urlImage.url ?? 'null'),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(LogoutEvent());
                        },
                        child: const Text('Logout'))
                  ],
                ),
              ),
            );
            // return AppPageController(
            //   friendRequests: state.friendRequests,
            //   chatRooms: state.chatRooms!,
            //   authUser: state.authUser!,
            //   listFriend: state.listFriend,
            // );
          }
          return LoginScreen(deviceToken: widget.deviceToken);
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

  _notificationServices() {
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
}
