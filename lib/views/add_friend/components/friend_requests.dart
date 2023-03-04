import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/views/add_friend/components/item_request_view.dart';
import 'package:chat_app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendRequestView extends StatelessWidget {
  final List<dynamic> friendRequests;
  const FriendRequestView({super.key, required this.friendRequests});

  @override
  Widget build(BuildContext context) {
    final maxHieght = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: AppLocalizations.of(context)!.friend_request,
          isUpper: false,
        ),
        Spaces.h20,
        Container(
          constraints: BoxConstraints(maxHeight: maxHieght),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              // final user = User.fromJson(friendRequests[index]['user']);
              final time = friendRequests[index]['time'];
              return Container();
              // return ItemRequestView(
              //   index: index,
              //   user: user,
              //   time: time,
              // );
            },
          ),
        ),
      ],
    );
  }
}
