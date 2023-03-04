import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool emojiShowing;
  const EmojiWidget({
    super.key,
    required this.controller,
    required this.emojiShowing,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: 280.h,
        child: EmojiPicker(
          textEditingController: controller,
          config: Config(
            columns: 7,
            emojiSizeMax:
                32 * (!foundation.kIsWeb && Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: const Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: Text(
              AppLocalizations.of(context)!.no_recents,
              style: TextStyle(fontSize: 20.h, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          ),
        ),
      ),
    );
  }
}
