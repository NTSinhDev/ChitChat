import 'dart:io';

import 'package:chat_app/res/injector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/view_model/injector.dart';

class StateAvatar extends StatelessWidget {
  final URLImage urlImage;
  final String userId;
  final double radius;
  const StateAvatar({
    Key? key,
    required this.urlImage,
    required this.userId,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildAvatar(context),
        if (userId.isNotEmpty)
          _RecievePresenceStreamData(
            userId: userId,
            child: buildGreenTickOnline,
          ),
      ],
    );
  }

  Widget buildGreenTickOnline(UserPresence? presence, bool theme) {
    return Visibility(
      visible: presence != null && presence.status,
      child: Positioned(
        // bottom: radius == 40.r ? -2.h : 2.h,
        bottom: 0,
        // right: radius == 40.r ? -1.w : 2.w,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 2.h,
          ),
          decoration: BoxDecoration(
            color: ResColors.appColor(isDarkmode: !theme),
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
    );
  }

  Widget buildAvatar(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;

    return SizedBox(
      width: radius,
      height: radius,
      child: urlImage.url == null
          ? CircleAvatar(
              backgroundColor: theme
                  ? ResColors.darkGrey(isDarkmode: false)
                  : ResColors.lightGrey(isDarkmode: true),
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.black,
                size: radius / 2,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              backgroundImage: urlImage.type == TypeImage.remote
                  ? NetworkImage(urlImage.url!)
                  : Image.file(File(urlImage.url!)).image,
            ),
    );
  }
}

class _RecievePresenceStreamData extends StatelessWidget {
  final String userId;
  final Widget Function(UserPresence?, bool) child;
  const _RecievePresenceStreamData({
    Key? key,
    required this.child,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenceStream = PresenceRemoteDatasourceImpl().getPresence(
      userID: userId,
    );
    final ThemeProvider theme = context.watch<ThemeProvider>();
    return StreamBuilder<DatabaseEvent>(
      stream: presenceStream,
      builder: (context, snapshotDBEvnet) {
        final bool condition1 = snapshotDBEvnet.hasData;
        final bool condition2 = snapshotDBEvnet.data != null;
        final bool condition3 = snapshotDBEvnet.data?.snapshot.value != null;
        UserPresence? presence;
        if (condition1 && condition2 && condition3) {
          final data = snapshotDBEvnet.data!.snapshot;
          final mapStringDynamic = Map<String, dynamic>.from(data.value as Map);
          presence = UserPresence.fromMap(mapStringDynamic, data.key!);
        }
        return child(presence, theme.isDarkMode);
      },
    );
  }
}
