import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/presentation/widgets/list_chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              14.w,
              14.h,
              14.w,
              0,
            ),
            child: Text(
              "Gần đây",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListChatRoom(
            listUsers: LIST_USERS,
            isGroup: false,
            isCall: true,
          ),
        ],
      ),
    );
  }
}
