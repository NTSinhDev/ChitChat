import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ForgotPasswordBtn extends StatelessWidget {
  const ForgotPasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10.h),
        child: Text(
          AppLocalizations.of(context)!.forgot_password,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
