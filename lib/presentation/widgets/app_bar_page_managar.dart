import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart'
    as IO; // ignore: library_prefixes

AppBar appBarPageManagar(
  String currentPage,
  BuildContext context,
  String img,
  String name,
  IO.Socket socket,
  int requests,
  Function() ontapAvatar,
) {
  AppStateProvider appState = context.watch<AppStateProvider>();
  return AppBar(
    toolbarHeight: 72.h,
    title: Row(
      children: [
        InkWell(
          onTap: ontapAvatar,
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Center(
              child: StateAvatar(
                avatar: img,
                isStatus: false,
                radius: 40.r,
              ),
            ),
          ),
        ),
        Text(
          currentPage,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    ),
    actions: [
      if (requests != 0) ...[
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {
                Provider.of<ChatBloc>(context, listen: false).add(
                  LookingForFriendEvent(),
                );
              },
              icon: Icon(
                CupertinoIcons.person_add_solid,
                color: appState.darkMode ? lightGreyDarkMode : darkGreyDarkMode,
                size: 30.r,
              ),
            ),
            if (requests != 0) ...[
              Positioned(
                top: 10.h,
                right: -2.w,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 22.h),
                  width: 20.w,
                  height: 20.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.h,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      '$requests',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
      SizedBox(width: 14.w),
    ],
  );
}
