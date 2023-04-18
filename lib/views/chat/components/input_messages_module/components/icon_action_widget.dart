part of '../input_messages_module.dart';

class IconActionWidget extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final bool visible;
  const IconActionWidget({
    super.key,
    required this.icon,
    this.onTap,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 25.r,
            color: AppColors(theme: theme).iconTheme,
          ),
        ),
      ),
    );
  }
}
