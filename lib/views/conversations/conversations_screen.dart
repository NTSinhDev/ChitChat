import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/views/conversations/components/search_bar.dart';
import 'package:chat_app/widgets/flash_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/conversations_listview.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    final routerProvider = context.watch<RouterProvider>();
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationInitial) {
          FlashMessageWidget(
              context: context,
              message: conversationBloc.fcmHanlder.deviceToken,
              type: FlashMessageType.success);
          conversationBloc.add(
            HandleNotificationServiceEvent(
              context: context,
              navigatorKey: routerProvider.navigatorKey,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(),
            Spaces.h20,
            // ListOnlineUser(listFriend: sortListUserToOnlState(listFriend!)),
            StreamBuilder<Iterable<Conversation>>(
              stream: conversationBloc.conversationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return ConversationsListView(conversations: snapshot.data!);
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
                    child: const Center(
                      child: Text(
                        "Let find some chat",
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
