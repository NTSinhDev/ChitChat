import 'package:chat_app/res/dimens.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/injector.dart';

class SignInOtherWays extends StatelessWidget {
  const SignInOtherWays({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.languagesExtension.or,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spaces.h10,
        Text(
          context.languagesExtension.login_with,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
