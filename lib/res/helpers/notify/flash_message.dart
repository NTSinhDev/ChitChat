import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/res/enum/enums.dart';
import 'package:provider/provider.dart';

class FlashMessage {
  final String message;
  final FlashMessageType type;

  FlashMessage({
    required BuildContext context,
    required this.message,
    required this.type,
  }) {
    _showMessage(context);
  }

  _showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      FlashMessageScreen(
        flashMessageModel: _createFlashMessageModel(context),
      ).build(context),
    );
  }

  FlashMessageModel _createFlashMessageModel(BuildContext context) {
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
        final title = AppLocalizations.of(context)!.error;

        return FlashMessageModel(
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
        final title = AppLocalizations.of(context)!.warning;

        return FlashMessageModel(
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
        final title = AppLocalizations.of(context)!.info;
        return FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
      case FlashMessageType.success:
        const Widget fontOf =
            Icon(Icons.check_circle, color: Colors.green, size: 22);
        const color = Colors.green;
        final title = AppLocalizations.of(context)!.success;
        return FlashMessageModel(
          fontOfTitle: fontOf,
          title: title,
          color: color,
          message: message,
        );
    }
  }
}

class FlashMessageScreen extends StatelessWidget {
  final FlashMessageModel flashMessageModel;

  const FlashMessageScreen({
    super.key,
    required this.flashMessageModel,
  });

  @override
  SnackBar build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

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
                color: flashMessageModel.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.h),
                  bottomLeft: Radius.circular(14.h),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.white,
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
                        color:
                            themeProvider.isDarkMode ? lightColor : darkColor,
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

class FlashMessageModel {
  final Widget fontOfTitle;
  final Color color;
  final String title;
  final String message;
  FlashMessageModel({
    required this.fontOfTitle,
    required this.color,
    required this.title,
    required this.message,
  });
}
