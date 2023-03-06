import 'package:chat_app/res/colors.dart';
import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputMessageWidget extends StatelessWidget {
  final Function(String)? onchange;
  final Function() ontapInput;
  final Function() ontapEmoji;
  final Function(String) onSubmitted;
  final TextEditingController inputController;
  const InputMessageWidget({
    super.key,
    this.onchange,
    required this.ontapInput,
    required this.inputController,
    required this.ontapEmoji,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: theme ? darkGreyDarkMode : lightGreyLightMode100,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spaces.w16,
            Expanded(
              child: TextField(
                maxLines: 6,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                onTap: ontapInput,
                style: Theme.of(context).textTheme.displaySmall,
                controller: inputController,
                onSubmitted: onSubmitted,
                onChanged: onchange,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: theme ? Colors.white : darkGreyLightMode,
                      ),
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.inbox,
                ),
              ),
            ),
            Spaces.w14,
            InkWell(
              onTap: ontapEmoji,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 6.w, 12.h),
                child: const Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
