import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'components/input_request.dart';
import 'components/loading_message.dart';

class AskChitChatcreen extends StatefulWidget {
  final UserProfile userProfile;
  const AskChitChatcreen({super.key, required this.userProfile});

  @override
  State<AskChitChatcreen> createState() => _AskChitChatcreenState();
}

class _AskChitChatcreenState extends State<AskChitChatcreen> {
  bool isTyping = false;
  final ScrollController scrollController = ScrollController();
  late final VirtualAssistantProvider assistantProvider;
  late final ThemeProvider theme;

  @override
  void initState() {
    super.initState();
    assistantProvider = context.read<VirtualAssistantProvider>();
    theme = context.read<ThemeProvider>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Xin chào! Tôi có thể giúp gì?",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: assistantProvider.getChatList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final isSender =
                        assistantProvider.getChatList[index].chatIndex == 0;
                    return MessageWidget(
                      isSender: isSender,
                      child: ContentOfMsgWidget(
                        content: assistantProvider.getChatList[index].msg,
                        isSender: isSender,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (isTyping) const LoadingMessage(),
            Spaces.h15,
            InputRequest(
              isTyping: (callback) => setState(() {
                if(!callback) scrollListToEND();
                isTyping = callback;
              }),
            ),
          ],
        ),
      ),
    );
  }

  scrollListToEND() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }
}
