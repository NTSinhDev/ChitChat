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
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.only(right: 14.w),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 28.r,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
