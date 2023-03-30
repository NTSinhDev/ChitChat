import 'dart:developer';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
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

  @override
  void initState() {
    super.initState();
    assistantProvider = context.read<VirtualAssistantProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme ? ResColors.mdblack : Colors.white,
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
      widget.isTyping(isTyping);
      textEditingController.clear();
      assistantProvider.addUserMessage(msg: msg);

      await assistantProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: "gpt-3.5-turbo-0301",
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