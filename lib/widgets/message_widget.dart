import 'package:chat_app/utils/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';

double _messageRadius = 14.r;

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.child,
    this.isSender = true,
    this.friend,
    this.width,
    this.showAvatar = false,
  }) : super(key: key);
  final Widget child;
  final bool isSender;
  final UserProfile? friend;
  final double? width;
  final String? time = '';
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: EdgeInsets.only(top: 3.5.h),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) _buildSenderMessageAvatar(),
          Container(
            constraints: BoxConstraints(maxWidth: width ?? maxWidth * 3.2 / 5),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: _buildBackgroundColor(theme),
              borderRadius: BorderRadius.only(
                bottomLeft: _buildLeftRadius(),
                bottomRight: _buildRightRadius(),
                topLeft: Radius.circular(_messageRadius),
                topRight: Radius.circular(_messageRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: _buildShadowColor(theme),
                  offset: _buildShadowOffset(),
                  blurRadius: 2,
                ),
              ],
              gradient: isSender
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors(theme: theme).gradientMessage,
                    )
                  : null,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Offset _buildShadowOffset() =>
      isSender ? const Offset(-1, -2) : const Offset(2, -2);

  Color _buildShadowColor(bool theme) {
    return isSender
        ? theme
            ? Colors.black38
            : Colors.black45
        : theme
            ? Colors.black26
            : Colors.black12;
  }

  Radius _buildRightRadius() =>
      isSender ? Radius.circular(3.r) : Radius.circular(_messageRadius);

  Radius _buildLeftRadius() =>
      isSender ? Radius.circular(_messageRadius) : Radius.circular(3.r);

  Color _buildBackgroundColor(bool theme) => isSender
      ? AppColors(theme: theme).baseTheme
      : theme
          ? AppColors.darkGrey(isDarkmode: theme)
          : AppColors.lightGrey(isDarkmode: theme);

  Widget _buildSenderMessageAvatar() => friend == null
      ? Container(
          // margin: EdgeInsets.only(right: 8.w),
          width: 8.w,
          // height: 32.r,
          // child: CircleAvatar(
          //   backgroundImage: Image.asset(ImgAnmStrings.iChitchat).image,
          // ),
        )
      : Container(
          margin: EdgeInsets.only(right: 8.w),
          width: 32.w,
          child: Visibility(
            visible: showAvatar,
            child: StateAvatar(
              urlImage: friend?.urlImage ?? URLImage(),
              userId: friend?.profile?.id,
              radius: 32.r,
            ),
          ),
        );

  Widget cloneForAudio({
    required BuildContext context,
    required double ratio,
    double? padding,
  }) {
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
                    bottomLeft: _buildLeftRadius(),
                    bottomRight: _buildRightRadius(),
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
                    bottomLeft: _buildLeftRadius(),
                    bottomRight: _buildRightRadius(),
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
}
