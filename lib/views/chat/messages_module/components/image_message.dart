import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final bool isMsgOfUser;
  final String path;
  final bool isAlone;
  final bool oneFile;
  final ui.Image? imgInfo;
  const ImageMessage({
    super.key,
    required this.isMsgOfUser,
    required this.path,
    required this.isAlone,
    required this.oneFile,
    this.imgInfo,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {},
      child: Container(
        constraints: BoxConstraints(
            maxWidth: isAlone ? maxWidth * 7 / 10 : maxWidth * 7 / 20,
            maxHeight: oneFile ? maxWidth * 7 / 10 : maxWidth * 7 / 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: _handleBoxFit(),
            image: CachedNetworkImageProvider(path),
          ),
        ),
      ),
    );
  }

  BoxFit _handleBoxFit() {
    if (imgInfo == null) return BoxFit.fitWidth;

    return imgInfo!.width > imgInfo!.height
        ? BoxFit.fitHeight
        : BoxFit.fitWidth;
  }

  // Widget _errorWidget(BuildContext context) {
  //   final theme = context.watch<ThemeProvider>().isDarkMode;
  //   return CannotLoadMsg(
  //     isSender: isMsgOfUser,
  //     theme: theme,
  //     content:context.languagesExtension.cannot_load_img,
  //   );
  // }

  // Widget _placeholderClipRRect(BuildContext context) {
  //   final theme = context.watch<ThemeProvider>().isDarkMode;
  //   return LoadingMessage(
  //     width: 214.w,
  //     isSender: isMsgOfUser,
  //     content: context.languagesExtension.loading_img,
  //   );
  // }
}
