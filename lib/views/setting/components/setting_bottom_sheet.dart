import 'package:chat_app/res/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingBtmSheet extends StatelessWidget {
  final String btmSheetTitle;
  final List<SettingBottomSheetItem> btmSheetItems;
  const SettingBtmSheet({
    Key? key,
    required this.btmSheetTitle,
    required this.btmSheetItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = _fetchBottomSheetItemToList(context: context);

    return Container(
      height: 180.h,
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 20.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.h),
          topRight: Radius.circular(12.h),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              btmSheetTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black),
            ),
            Spaces.h8,
            ...items,
          ],
        ),
      ),
    );
  }

  List<Widget> _fetchBottomSheetItemToList({required BuildContext context}) =>
      btmSheetItems
          .map((bottomSheetItem) => ListTile(
                onTap: bottomSheetItem.ontap,
                leading: bottomSheetItem.leading,
                title: Text(
                  bottomSheetItem.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ),
                trailing: bottomSheetItem.trailing,
              ))
          .toList();
}

class SettingBottomSheetItem {
  final Function()? ontap;
  final Widget leading;
  final String title;
  final Widget? trailing;
  SettingBottomSheetItem({
    required this.ontap,
    required this.leading,
    required this.title,
    this.trailing,
  });
}
