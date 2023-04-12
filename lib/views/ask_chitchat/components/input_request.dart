import 'dart:developer';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/view_model/providers/apikey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class InputRequest extends StatefulWidget {
  final Function(bool) isTyping;
  const InputRequest({super.key, required this.isTyping});

  @override
  State<InputRequest> createState() => _InputRequestState();
}

class _InputRequestState extends State<InputRequest> {
  bool isTyping = false;
  final TextEditingController textEditingController = TextEditingController();
  late final VirtualAssistantProvider assistantProvider;
  late final APIKeyProvider apiKeyProvider;

  @override
  void initState() {
    super.initState();
    assistantProvider = context.read<VirtualAssistantProvider>();
    apiKeyProvider = context.read<APIKeyProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme ? AppColors.mdblack : Colors.white,
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
                  maxLines: 6,
                  minLines: 1,
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
                icon: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: AppColors.purpleMessage(theme: theme),
                ),
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
      widget.isTyping(isTyping);
      textEditingController.clear();
      assistantProvider.addUserMessage(msg: msg);

      await assistantProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: "gpt-3.5-turbo-0301",
        apiKey: apiKeyProvider.chatGPTKey,
      );
    } catch (error) {
      log("error $error");
      assistantProvider.addErrorMessage(msg: error.toString());
    } finally {
      setState(() {
        isTyping = false;
      });
      widget.isTyping(isTyping);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
