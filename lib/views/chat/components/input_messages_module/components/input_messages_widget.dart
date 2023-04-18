part of '../input_messages_module.dart';

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
          color: AppColors(theme: theme).themeModeOpacity,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spaces.w14,
            Expanded(
              child: TextField(
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                onTap: ontapInput,
                style: Theme.of(context).textTheme.displaySmall,
                controller: inputController,
                onSubmitted: onSubmitted,
                onChanged: onchange,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: theme
                            ? Colors.white
                            : AppColors.darkGrey(isDarkmode: false),
                      ),
                  border: InputBorder.none,
                  hintText: context.languagesExtension.inbox,
                ),
              ),
            ),
            Spaces.w14,
            InkWell(
              onTap: ontapEmoji,
              child: Container(
                margin: EdgeInsets.only(right: 6.w, bottom: 12.h),
                child: Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: AppColors(theme: theme).iconTheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
