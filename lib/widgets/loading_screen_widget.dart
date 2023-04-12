import 'dart:async';

import 'package:chat_app/res/colors.dart';
import 'package:flutter/material.dart';

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}

class LoadingScreenWidget {
  factory LoadingScreenWidget() => _shared;
  static final LoadingScreenWidget _shared =
      LoadingScreenWidget._sharedInstance();
  LoadingScreenWidget._sharedInstance();

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
    final streamController = StreamController<String>();
    streamController.add(text ?? '');

    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: const Center(
            child: SingleChildScrollView(
              child: CircularProgressIndicator(color: AppColors.redAccent),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        streamController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        streamController.add(text);
        return true;
      },
    );
  }
}
