import 'dart:async';

import 'package:chat_app/presentation/helper/loading/loading_screen_controller.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    String? text,
  }) {
    if (controller?.update(text ?? '') ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    String? text,
  }) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _text = StreamController<String>();
    _text.add(text ?? '');

    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 76.w,
                height: 76.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  // color: Colors.white38,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 40.h),
                    // SpinKitCircle(
                    //   color: redAccent,
                    //   size: 72.w,
                    // ),
                    const CircularProgressIndicator(
                      color: redAccent,
                    ),
                    // SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
