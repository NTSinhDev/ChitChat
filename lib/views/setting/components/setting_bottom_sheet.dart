import 'package:chat_app/res/colors.dart';
import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final theme = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      height: 220.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.appColor(isDarkmode: !theme),
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
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Spaces.h8,
            ...items,
          ],
        ),
      ),
    );
  }

  List<Widget> _fetchBottomSheetItemToList({required BuildContext context}) {
    final isDarkmode = context.watch<ThemeProvider>().isDarkMode;
    return btmSheetItems
        .map((bottomSheetItem) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 5,
              ),
              decoration: BoxDecoration(
                color: bottomSheetItem.isActive
                    ? AppColors(theme: isDarkmode).iconTheme
                    : AppColors.appColor(isDarkmode: isDarkmode)
                        .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                onTap: bottomSheetItem.ontap,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    bottomSheetItem.leading,
                    Spaces.w14,
                    Text(
                      bottomSheetItem.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color:
                                bottomSheetItem.isActive ? Colors.white : null,
                          ),
                    ),
                    Spaces.w20,
                  ],
                ),
              ),
            ))
        .toList();
  }
}

class SettingBottomSheetItem {
  final Function()? ontap;
  final Widget leading;
  final String title;
  final bool isActive;
  SettingBottomSheetItem({
    required this.ontap,
    required this.leading,
    required this.title,
    this.isActive = false,
  });
}
