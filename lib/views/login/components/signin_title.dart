import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInTitle extends StatelessWidget {
  const SignInTitle({super.key});

  @override
  Widget build(BuildContext context) {
   return Text(
      AppLocalizations.of(context)!.login,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: Colors.white70,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}