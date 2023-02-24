import 'package:chat_app/data/environment.dart';
import 'package:chat_app/data/repository/auth_repository.dart';
import 'package:chat_app/features/authentication/domain/usecases/logout.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/presentation/helper/loading/loading_screen.dart';
import 'package:chat_app/presentation/pages/page_controller.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/login_screen.dart';
import 'package:chat_app/features/authentication/presentation/pages/signup/signup_screen.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/utils/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthentication extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final String? tokenUser;
  final String deviceToken;
  const AppAuthentication({
    Key? key,
    required this.sharedPreferences,
    this.tokenUser,
    required this.deviceToken,
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
        AuthRepository(
          environment: Environment(isServerDev: true),
        ),
        widget.sharedPreferences,
      )..add(widget.tokenUser != null
          ? LoginByAccessTokenEvent()
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
            final name = state.profile==null?"Unknowned":state.profile!.fullName;
            return Scaffold(
              body: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is LoggedState) {
                    if (state.loading) {
                      LoadingScreen().show(context: context);
                    } else {
                      LoadingScreen().hide();
                    }
                  }
                },
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text(name)),
                      TextButton(
                          onPressed: () {
                            context.read<AuthenticationBloc>().add(LogoutEvent());
                          },
                          child: const Text('Logout'))
                    ],
                  ),
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
