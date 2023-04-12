import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/services/injector.dart';
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
    return SizedBox(
      width: 178.w,
      height: 48.h,
      child: FloatingActionButton(
        onPressed: () => _navigateAskChitChatScreen(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100.r),
            bottomRight: const Radius.circular(0),
            topLeft: Radius.circular(100.r),
            topRight: Radius.circular(100.r),
          ),
        ),
        backgroundColor: AppColors(themeMode: theme).baseTheme,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Future<void> _navigateAskChitChatScreen(BuildContext context) async {
    final apiProvider = context.watch<APIKeyProvider>();

    await FCMHanlder.sendMessage(
      conversationID: userProfile.profile!.id!,
      userProfile: userProfile.profile!,
      friendProfile: userProfile.profile!,
      message:
          " sdlakjlk jsalkjd lkjsalkjd lkjsadl jlsajd lkjsaldj lksajdl kjsaljd ljsalkd jlksajd lksaldj lsajd lksalkdj lksajd lkjsalkd jlksajd lkjsald jsajd lsald jlsad lksjadj lskajd lkjsald jlksajd jsalkd jlkasjd lkjsald klsajd lkjsakd jlksajd lkjsalkd jsakjd ;ksaj;k dja;kfj;ksaf j;l sajf;jsa;kfj jaksf kjafs lkjsa kkasffj lkasjf lkaslk laksfj lkfa sj;kafskj ",
      apiKey: apiProvider.messagingServerKey,
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AskChitChatcreen(userProfile: userProfile),
    //   ),
    // );
  }
}
