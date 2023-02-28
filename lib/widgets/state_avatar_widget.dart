import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/view_model/providers/app_state_provider.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StateAvatar extends StatefulWidget {
  final URLImage urlImage;
  final bool isStatus;
  final double radius;
  const StateAvatar({
    Key? key,
    required this.urlImage,
    required this.isStatus,
    required this.radius,
  }) : super(key: key);

  @override
  State<StateAvatar> createState() => _StateAvatarState();
}

class _StateAvatarState extends State<StateAvatar> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeApp = context.watch<ThemeProvider>();
    return Stack(
      children: [
        _buildAvatar(themeApp),
        if (widget.isStatus) ...[
          _buildGreenTickOnline(themeApp),
        ],
      ],
    );
  }

  Widget _buildGreenTickOnline(ThemeProvider themeApp) {
    return Positioned(
      bottom: widget.radius == 40.r ? -2.h : 2.h,
      right: widget.radius == 40.r ? -1.w : 2.w,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          color: themeApp.isDarkMode ? const Color(0xFF303030) : Colors.white,
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
    );
  }

  Widget _buildAvatar(ThemeProvider themeApp) {
    return SizedBox(
      width: widget.radius,
      height: widget.radius,
      child: widget.urlImage.url == null
          ? CircleAvatar(
              backgroundColor:
                  themeApp.isDarkMode ? darkGreyLightMode : lightGreyDarkMode,
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.black,
                size: widget.radius / 2,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              backgroundImage: widget.urlImage.type == TypeImage.remote
                  ? NetworkImage(widget.urlImage.url!)
                  : Image.file(File(widget.urlImage.url!)).image,
            ),
    );
  }
}
