import 'package:chat_app/res/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionsRecommend extends StatefulWidget {
  const OptionsRecommend({super.key});

  @override
  State<OptionsRecommend> createState() => _OptionsRecommendState();
}

class _OptionsRecommendState extends State<OptionsRecommend> {
  final options = [
    "Tất cả",
    "Hiện diện",
    "Gần đây",
    "Thân mật",
    // "Mới",
  ];
  late String selected;
  @override
  void initState() {
    super.initState();
    selected = options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 8.w,
      runSpacing: 8.h,
      children: options
          .map((option) => optionItem(
                () {
                  setState(() {
                    selected = option;
                  });
                },
                name: option,
              ))
          .toList(),
    );
  }

  Widget optionItem(Function() callback, {required String name}) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 13.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: selected == name
              ? AppColors.customNewDarkPurple
              : AppColors.backgroundLightPurple,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: selected == name
                      ? Colors.white
                      : AppColors.customNewMediumPurple),
            ),
          ],
        ),
      ),
    );
  }
}
