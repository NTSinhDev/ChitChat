import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/view_model/providers/theme_provider.dart';
import 'package:chat_app/views/ask_chitchat/ask_chitchat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AskAIButton extends StatelessWidget {
  final UserProfile userProfile;
  const AskAIButton({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(20.r),
      bottomRight: Radius.circular(4.r),
      topLeft: Radius.circular(20.r),
      topRight: Radius.circular(20.r),
    );
    return SizedBox(
      width: 178.w,
      height: 48.h,
      child: FloatingActionButton(
        onPressed: () => _navigateAskChitChatScreen(context),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: Colors.transparent,
        child: Ink(
          height: 48.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors(theme: theme).gradientMessage,
            ),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.solidComments),
              Spaces.w12,
              Text(
                context.languagesExtension.ask_ChitChat,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white, fontSize: 13.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAskChitChatScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AskChitChatcreen(userProfile: userProfile),
      ),
    );
  }
}
