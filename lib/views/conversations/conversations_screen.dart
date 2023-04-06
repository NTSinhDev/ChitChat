import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/conversations/components/list_online_user.dart';
import 'package:chat_app/views/conversations/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/conversations_listview.dart';

class ConversationScreen extends StatelessWidget {
  final FCMHanlder fcmHanlder;
  const ConversationScreen({
    super.key,
    required this.fcmHanlder,
  });

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(),
            Spaces.h12,
            StreamBuilder<List<ConversationData>>(
              stream: conversationBloc.conversationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      ListOnlineUser(conversationsData: snapshot.data!),
                      ConversationsListView(conversations: snapshot.data!),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
