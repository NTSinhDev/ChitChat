import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertActions extends StatelessWidget {
  final Widget content;
  final String nameBtn1;
  final Function() onTap1;
  final String nameBtn2;
  final Function() onTap2;
  const AlertActions({
    super.key,
    required this.content,
    required this.nameBtn1,
    required this.nameBtn2,
    required this.onTap1,
    required this.onTap2,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          child: CustomBtnWidget(title: nameBtn1, onPressed: onTap1),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          child: CustomBtnWidget(
            title: nameBtn2,
            onPressed: onTap2,
            backgroundColor: darkGreyLightMode,
          ),
        ),
      ],
    );
  }
}
