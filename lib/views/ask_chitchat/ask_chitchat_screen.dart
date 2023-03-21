import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/ask_chitchat/components/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'components/virtual_assistant_message.dart';

class AskChitChatcreen extends StatefulWidget {
  final UserProfile userProfile;
  const AskChitChatcreen({super.key, required this.userProfile});

  @override
  State<AskChitChatcreen> createState() => _AskChitChatcreenState();
}

class _AskChitChatcreenState extends State<AskChitChatcreen> {
  bool isTyping = false;
  final TextEditingController textEditingController = TextEditingController();
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
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
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
                  itemBuilder: (context, index) => VirtualAssistantMessage(
                    msg: assistantProvider.getChatList[index].msg,
                    chatIndex: assistantProvider.getChatList[index].chatIndex,
                    shouldAnimate:
                        assistantProvider.getChatList.length - 1 == index,
                    userProfile: widget.userProfile,
                  ),
                ),
              ),
            ),
            if (isTyping)
              Container(
                margin: EdgeInsets.only(top: 12.h, left: 14.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 14.w),
                      width: 36.h,
                      height: 36.h,
                      child: CircleAvatar(
                        backgroundImage:
                            Image.asset(ImgAnmStrings.iChitchat).image,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      padding: EdgeInsets.all(12.h),
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: theme
                            ? ResColors.darkGrey(isDarkmode: theme)
                            : ResColors.lightGrey(isDarkmode: theme),
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(0),
                          bottomRight: Radius.circular(32.r),
                          topLeft: Radius.circular(32.r),
                          topRight: Radius.circular(32.r),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(-1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: SpinKitThreeBounce(
                        color: theme ? Colors.white : Colors.black,
                        size: 14.r,
                      ),
                    ),
                  ],
                ),
              ),
            Spaces.h15,
            inputRequest(context),
          ],
        ),
      ),
    );
  }

  Widget inputRequest(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.isDarkMode ? ResColors.mdblack : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(5, 5),
            blurRadius: 7,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: textEditingController,
                  onSubmitted: (value) async => await sendMessageFCT(),
                  decoration: InputDecoration.collapsed(
                    hintText: "\tBạn muốn hỏi gì?",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessageFCT,
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future sendMessageFCT() async {
    if (textEditingController.text.isEmpty || isTyping) return;

    try {
      String msg = textEditingController.text;

      setState(() {
        isTyping = true;
      });
      textEditingController.clear();
      assistantProvider.addUserMessage(msg: msg);

      await assistantProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: "gpt-3.5-turbo-0301",
      );
    } catch (error) {
      log("error $error");
      SnackBarWidget.show(context: context, label: "$error");
    } finally {
      setState(() {
        scrollListToEND();
        isTyping = false;
      });
    }
  }

  scrollListToEND() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }
}
