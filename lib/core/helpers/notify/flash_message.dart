// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/core/res/images_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app/core/enum/enums.dart';
import 'package:lottie/lottie.dart';

class FlashMessage {
  final String title;
  final String content;
  final FlashMessageType type;

  FlashMessage({
    required BuildContext context,
    required this.title,
    required this.content,
    required this.type,
  }) {
    _showMessage(context);
  }

  _showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(FlashMessageScreen(
      title: title,
      content: content,
      type: type,
    ).build(context));
  }
}

class FlashMessageScreen extends StatelessWidget {
  final String title;
  final String content;
  final FlashMessageType type;

  const FlashMessageScreen({
    super.key,
    required this.title,
    required this.content,
    required this.type,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 5),
      padding: EdgeInsets.fromLTRB(100.w, 12.h, 12.w, 12.h),
      content: Container(
        height: 56.h,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(4, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              decoration: BoxDecoration(
                color: _handleColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.h),
                  bottomLeft: Radius.circular(14.h),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _fontOfTitleWidget(),
                              SizedBox(width: 4.w),
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 12.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            content,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: darkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fontOfTitleWidget() {
    switch (type) {
      case FlashMessageType.error:
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          width: 28,
          child: Lottie.asset(
            ImgAnmConstants.aFailed,
            fit: BoxFit.fitWidth,
          ),
        );
      case FlashMessageType.warning:
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          width: 28,
          child: Lottie.asset(
            ImgAnmConstants.aWarning,
            fit: BoxFit.fitWidth,
          ),
        );
      case FlashMessageType.info:
        return const Icon(
          Icons.info,
          color: Colors.blue,
          size: 24,
        );
      case FlashMessageType.success:
        return const Icon(Icons.check_circle, color: Colors.green, size: 22);
      default:
        return const Icon(Icons.check_circle, color: Colors.green, size: 22);
    }
  }

  Color _handleColor() {
    switch (type) {
      case FlashMessageType.error:
        return Colors.red;
      case FlashMessageType.warning:
        return Colors.orange;
      case FlashMessageType.info:
        return Colors.blue;
      case FlashMessageType.success:
        return Colors.green;
      default:
        return Colors.green;
    }
  }
}
