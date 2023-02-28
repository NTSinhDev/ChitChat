import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/view_model/providers/app_state_provider.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

AppBar appBarPageManagar({
  required String currentPage,
  required BuildContext context,
  required URLImage urlImage,
  required String name,
  required int requests,
  required Function() ontapAvatar,
}) {
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
                urlImage: urlImage,
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
