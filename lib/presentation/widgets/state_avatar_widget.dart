import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';

class StateAvatar extends StatefulWidget {
  final String avatar;
  final bool isStatus;
  final double radius;
  const StateAvatar({
    Key? key,
    required this.avatar,
    required this.isStatus,
    required this.radius,
  }) : super(key: key);

  @override
  State<StateAvatar> createState() => _StateAvatarState();
}

class _StateAvatarState extends State<StateAvatar> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    return Stack(
      children: [
        _avatarWidget(appState),
        if (widget.isStatus) ...[
          Positioned(
            bottom: widget.radius == 40.r
                ? -2.h
                : 2.h,
            right: widget.radius == 40.r
                ? -1.w
                : 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color:
                    appState.darkMode ? const Color(0xFF303030) : Colors.white,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Container(
                width: 10.h,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  SizedBox _avatarWidget(AppStateProvider appState) {
    return SizedBox(
      width: widget.radius,
      height: widget.radius,
      child: widget.avatar == ''
          ? CircleAvatar(
              backgroundColor:
                  appState.darkMode ? darkGreyLightMode : lightGreyDarkMode,
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.black,
                size: widget.radius / 2,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              backgroundImage: CachedNetworkImageProvider(
                widget.avatar,
              ),
            ),
    );
  }
}
