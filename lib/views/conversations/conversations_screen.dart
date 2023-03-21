import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/conversations.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 14.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!appState.hasConnect) ...[
          //   const NoInternetText(),
          // ],
          const SearchBar(),
          Spaces.h12,
          // ListOnlineUser(listFriend: sortListUserToOnlState(listFriend!)),
          StreamBuilder<Iterable<Conversation>>(
            stream: conversationBloc.conversationsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return Conversations(conversations: snapshot.data!);
              }
              return Padding(
                padding: EdgeInsets.only(top: 280.h),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => SearchBloc(
                            currentUser: conversationBloc.currentUser,
                          ),
                          child: const SearchScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Let find some chat",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
