import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/conversations/components/empty_conversations.dart';
import 'package:chat_app/views/conversations/components/list_online_user.dart';
import 'package:chat_app/views/conversations/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/conversations_listview.dart';

class ConversationScreen extends StatefulWidget {
  final FCMHanlder fcmHanlder;
  final Function(bool) scrollCallBack;
  const ConversationScreen({
    super.key,
    required this.fcmHanlder,
    required this.scrollCallBack,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    final routerProvider = context.watch<RouterProvider>();
    final conversationBloc = context.read<ConversationBloc>();
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationInitial) {
          conversationBloc.add(HandleNotificationServiceEvent(
              context: context, navigatorKey: routerProvider.navigatorKey));
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {},
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              double scrollOffset = scrollNotification.metrics.pixels;
              if (scrollOffset <= 0) {
                widget.scrollCallBack(true);
              } else {
                widget.scrollCallBack(false);
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20.h),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SearchBar(),
                Spaces.h20,
                const ListOnlineUser(),
                StreamBuilder<Iterable<Conversation>>(
                  stream: conversationBloc.conversationsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return ConversationsListView(
                          conversations: snapshot.data!);
                    }
                    return const EmptyConversation();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
