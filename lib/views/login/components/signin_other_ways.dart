import 'package:chat_app/core/res/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SignInOtherWays extends StatelessWidget {
  const SignInOtherWays({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.or,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spaces.h10,
        Text(
          AppLocalizations.of(context)!.login_with,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
