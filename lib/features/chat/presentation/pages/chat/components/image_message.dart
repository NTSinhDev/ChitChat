import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/chat/presentation/pages/chat/components/loading_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'cannot_load_img.dart';

class ImageMessage extends StatelessWidget {
  final bool isSender;
  final bool theme;
  final String path;
  const ImageMessage({
    super.key,
    required this.isSender,
    required this.theme,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth * 7 / 10,
        maxHeight: 440.h,
      ),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isSender ? Colors.black45 : Colors.black12,
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: "https://appsocketonline2.herokuapp.com$path",
          fit: BoxFit.contain,
          placeholder: (context, url) => LoadingMessage(
            width: 214.w,
            isSender: isSender,
            theme: theme,
            content: AppLocalizations.of(context)!.loading_img,
          ),
          errorWidget: (context, url, error) => CannotLoadMsg(
            isSender: isSender,
            theme: theme,
            content: AppLocalizations.of(context)!.cannot_load_img,
          ),
        ),
      ),
    );
  }
}
