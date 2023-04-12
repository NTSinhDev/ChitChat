import 'package:chat_app/services/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class InitializeStateManagers extends StatelessWidget {
  final FCMHanlder fcmHanlder;
  final Widget child;
  const InitializeStateManagers({
    super.key,
    required this.fcmHanlder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthenticationBloc>().userProfile!;
    final routerProvider = context.watch<RouterProvider>();
    return BlocProvider<ConversationBloc>(
      create: (_) => ConversationBloc(
        currentUser: currentUser,
        fcmHanlder: fcmHanlder,
        routerProvider: routerProvider,
      )
        ..add(ListenConversationsEvent())
        ..add(HandleNotificationServiceEvent(
          context: context,
          navigatorKey: routerProvider.navigatorKey,
          serverKey: context.watch<APIKeyProvider>().messagingServerKey,
        )),
      child: ChangeNotifierProvider(
        create: (_) => FriendsProvider(currentUser: currentUser.profile!),
        child: child,
      ),
    );
  }
}
