import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/providers/theme_provider.dart';
import 'package:chat_app/views/ask_chitchat/ask_chitchat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AskAIButton extends StatelessWidget {
  final UserProfile userProfile;
  const AskAIButton({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return SizedBox(
      width: 140.w,
      height: 48.h,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AskChitChatcreen(userProfile: userProfile),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100.r),
            bottomRight: const Radius.circular(0),
            topLeft: Radius.circular(100.r),
            topRight: Radius.circular(100.r),
          ),
        ),
        backgroundColor:
            theme ? ResColors.darkPurple : ResColors.deepPurpleAccent,
        child: Text(
          AppLocalizations.of(context)!.ask_ChitChat,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white, fontSize: 13.0),
        ),
      ),
    );
  }
}
