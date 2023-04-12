import 'dart:io';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/view_model/injector.dart';

class StateAvatar extends StatelessWidget {
  final URLImage urlImage;
  final String userId;
  final double radius;
  final Color? color;
  final bool isBorder;
  final BoxShadow? boxShadow;
  const StateAvatar({
    Key? key,
    required this.urlImage,
    required this.userId,
    required this.radius,
    this.color,
    this.isBorder = false,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Stack(
      children: [
        _buildAvatar(theme),
        if (userId.isNotEmpty) _buildGreenTickOnline(theme),
      ],
    );
  }

  Widget _buildGreenTickOnline(bool theme) {
    return PresenceStreamWidget(
      userId: userId,
      child: (presence) {
        return Visibility(
          visible: presence?.status ?? false,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: radius / (20 + radius ~/ 40),
                vertical: radius / (20 + radius ~/ 40),
              ),
              decoration: BoxDecoration(
                color: color ?? AppColors.appColor(isDarkmode: !theme),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Container(
                width: radius / (4 + radius ~/ 40),
                height: radius / (4 + radius ~/ 40),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(bool theme) {
    return Container(
      padding: isBorder ? EdgeInsets.all(radius / 40) : null,
      decoration: isBorder
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                boxShadow ??
                    const BoxShadow(
                      color: Colors.black54,
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
              ],
            )
          : null,
      width: radius,
      height: radius,
      child: urlImage.url == null
          ? CircleAvatar(
              backgroundColor: theme
                  ? AppColors.darkGrey(isDarkmode: false)
                  : AppColors.lightGrey(isDarkmode: true),
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
