import 'package:flutter/material.dart';
import 'package:chat_app/utils/injector.dart';

class SignInTitle extends StatelessWidget {
  const SignInTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.languagesExtension.login,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: Colors.white70,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
