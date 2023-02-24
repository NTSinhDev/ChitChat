import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/presentation/widgets/list_chat_room.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/presentation/widgets/search_bar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(theme: appState.darkMode),
          Container(
            margin: EdgeInsets.fromLTRB(
              14.w,
              14.h,
              14.w,
              0,
            ),
            child: Text(
              "Nhóm",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListChatRoom(
            listUsers: LIST_USERS,
            isGroup: false,
          ),
        ],
      ),
    );
  }
}
