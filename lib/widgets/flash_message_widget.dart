import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FlashMessageWidget {
  final String message;
  final FlashMessageType type;

  FlashMessageWidget({
    required BuildContext context,
    required this.message,
    required this.type,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _FlashMessageScreen(
        flashMessageModel: _createFlashMessageModel(context),
      ).build(context),
    );
  }

  _FlashMessageModel _createFlashMessageModel(BuildContext context) {
    switch (type) {
      case FlashMessageType.error:
        final Widget fontOf = SizedBox(
          width: 24,
          child: Lottie.asset(
            ImgAnmStrings.aFailed,
            fit: BoxFit.fitWidth,
          ),
        );
        const color = Colors.red;
        final title = context.languagesExtension.error;

        return _FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
      case FlashMessageType.warning:
        final Widget fontOf = SizedBox(
          width: 24,
          child: Lottie.asset(
            ImgAnmStrings.aWarning,
            fit: BoxFit.fitWidth,
          ),
        );
        const color = Colors.orange;
        final title = context.languagesExtension.warning;

        return _FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
      case FlashMessageType.info:
        const Widget fontOf = Icon(
          Icons.info,
          color: Colors.blue,
          size: 24,
        );
        const color = Colors.blue;
        final title = context.languagesExtension.info;
        return _FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
      case FlashMessageType.success:
        const Widget fontOf =
            Icon(Icons.check_circle, color: Colors.green, size: 22);
        const color = Colors.green;
        final title = context.languagesExtension.success;
        return _FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
    }
  }
}

class _FlashMessageScreen extends StatelessWidget {
  final _FlashMessageModel flashMessageModel;

  const _FlashMessageScreen({
    required this.flashMessageModel,
  });

  @override
  SnackBar build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);

    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 5),
      padding: EdgeInsets.fromLTRB(100.w, 12.h, 12.w, 12.h),
      content: Container(
        height: 56.h,
        decoration: ResDecorate.boxShadowBlack38,
        child: Row(
          children: [
            Container(
              width: 10.w,
              decoration: ResDecorate.boxColor(color: flashMessageModel.color),
            ),
            Expanded(
              child: Container(
                color: theme.isDarkMode ? Colors.grey.shade800 : Colors.white,
                child: Row(
                  children: [
                    Spaces.w14,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              flashMessageModel.fontOfTitle,
                              Spaces.w10,
                              Text(
                                flashMessageModel.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 12.0),
                              ),
                            ],
                          ),
                          Spaces.h2,
                          Text(
                            flashMessageModel.message,
                            overflow: TextOverflow.ellipsis,
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
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.appColor(isDarkmode: theme.isDarkMode),
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
}

class _FlashMessageModel {
  final Widget fontOfTitle;
  final Color color;
  final String title;
  final String message;
  _FlashMessageModel({
    required this.fontOfTitle,
    required this.color,
    required this.title,
    required this.message,
  });
}
