import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';

double _messageRadius = 34.r;

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.child,
    this.isSender = true,
    this.friend,
    this.width,
  }) : super(key: key);
  final Widget child;
  final bool isSender;
  final UserProfile? friend;
  final double? width;
  final String? time = '';

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) _buildSenderMessageAvatar(),
          Container(
            constraints: BoxConstraints(maxWidth: width ?? maxWidth * 3 / 5),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: _buildBackgroundColor(theme),
              borderRadius: BorderRadius.only(
                bottomLeft: _buildBottomLeftRadius(),
                bottomRight: _buildBottomRightRadius(),
                topLeft: Radius.circular(_messageRadius),
                topRight: Radius.circular(_messageRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: _buildShadowColor(theme),
                  offset: _buildShadowOffset(),
                  blurRadius: 3,
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget cloneForAudio(
      {required BuildContext context, required double ratio, double? padding}) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) _buildSenderMessageAvatar(),
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: width ?? maxWidth * 3 / 5,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: padding ?? 12.h,
                  horizontal: 16.w,
                ),
                decoration: BoxDecoration(
                  color: _buildBackgroundColor(theme),
                  borderRadius: BorderRadius.only(
                    bottomLeft: _buildBottomLeftRadius(),
                    bottomRight: _buildBottomRightRadius(),
                    topLeft: Radius.circular(_messageRadius),
                    topRight: Radius.circular(_messageRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _buildShadowColor(theme),
                      offset: _buildShadowOffset(),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: child,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: width ?? maxWidth * 3 / 5,
                ),
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Colors.black12, Colors.transparent],
                    stops: [ratio, 0.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: _buildBottomLeftRadius(),
                    bottomRight: _buildBottomRightRadius(),
                    topLeft: Radius.circular(_messageRadius),
                    topRight: Radius.circular(_messageRadius),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Offset _buildShadowOffset() =>
      isSender ? const Offset(-1, -1) : const Offset(1, -1);

  Color _buildShadowColor(bool theme) {
    return isSender
        ? theme
            ? Colors.black38
            : Colors.black45
        : theme
            ? Colors.black26
            : Colors.black12;
  }

  Radius _buildBottomRightRadius() =>
      isSender ? const Radius.circular(0) : Radius.circular(_messageRadius);

  Radius _buildBottomLeftRadius() =>
      isSender ? Radius.circular(_messageRadius) : const Radius.circular(0);

  Color _buildBackgroundColor(bool theme) => isSender
      ? ResColors.purpleMessage(theme: theme)
      : theme
          ? ResColors.darkGrey(isDarkmode: theme)
          : ResColors.lightGrey(isDarkmode: theme);

  Widget _buildSenderMessageAvatar() => friend == null
      ? Container(
          margin: EdgeInsets.only(right: 12.w),
          width: _messageRadius,
          height: _messageRadius,
          child: CircleAvatar(
            backgroundImage: Image.asset(ImgAnmStrings.iChitchat).image,
          ),
        )
      : Container(
          margin: EdgeInsets.only(right: 12.w),
          child: StateAvatar(
            urlImage: friend?.urlImage ?? URLImage(),
            userId: friend?.profile?.id ?? '',
            radius: _messageRadius,
          ),
        );
}
