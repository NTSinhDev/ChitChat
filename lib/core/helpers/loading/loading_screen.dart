import 'dart:async';

import 'package:chat_app/core/res/colors.dart';
import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

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
    final streamController = StreamController<String>();
    streamController.add(text ?? '');

    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: const Center(
            child: SingleChildScrollView(
              child: CircularProgressIndicator(color: redAccent),
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
