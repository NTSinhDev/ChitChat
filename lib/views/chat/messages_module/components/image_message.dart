import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/messages_module/components/loading_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'cannot_load_img.dart';

class ImageMessage extends StatelessWidget {
  final bool isMsgOfUser;
  final List<String> paths;
  const ImageMessage({
    super.key,
    required this.isMsgOfUser,
    required this.paths,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final theme = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment:
            isMsgOfUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: paths.map((path) {
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
                  color: isMsgOfUser ? Colors.black45 : Colors.black12,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: path,
                fit: BoxFit.contain,
                placeholder: (context, url) => LoadingMessage(
                  width: 214.w,
                  isSender: isMsgOfUser,
                  theme: theme,
                  content: AppLocalizations.of(context)!.loading_img,
                ),
                errorWidget: (context, url, error) => CannotLoadMsg(
                  isSender: isMsgOfUser,
                  theme: theme,
                  content: AppLocalizations.of(context)!.cannot_load_img,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
