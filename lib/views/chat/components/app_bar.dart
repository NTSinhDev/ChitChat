import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/views/information_chat_room/information_chat_room.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar buildAppBar({
  required BuildContext context,
  required String roomID,
}) {
  // final friend = context.watch<ChatBloc>().friend;
  return AppBar(
    toolbarHeight: 72.h,
    leading: BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<ChatBloc>(context, listen: false)
                .add(ExitRoomEvent(roomID: roomID));
          },
        );
      },
    ),
    title: BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is HasSourceChatState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StateAvatar(
                avatar: '',
                // avatar: state.friend.urlImage!,
                isStatus: state.isOnl,
                radius: 40.r,
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // formatName(name: state.friend.name!),
                    '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (state.isOnl) ...[
                    Text(
                      AppLocalizations.of(context)!.onl,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 10.r),
                    ),
                  ]
                ],
              ),
            ],
          );
        }
        return const Center(child: Text("error"));
      },
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>Container()
                    // InformationChatRoomScreen(friend: null),
              ));
        },
        icon: Icon(
          CupertinoIcons.info_circle_fill,
          color: Colors.blue,
          size: 30.r,
        ),
      ),
      SizedBox(
        width: 4.h,
      ),
    ],
  );
}
