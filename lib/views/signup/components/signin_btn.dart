import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/view_model/blocs/authentication/bloc_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInBtn extends StatelessWidget {
  const SignInBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            child: Text(
              AppLocalizations.of(context)!.have_an_account,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spaces.h8,
          InkWell(
            onTap: () {
              context.read<AuthenticationBloc>().add(InitLoginEvent());
            },
            child: Text(
              AppLocalizations.of(context)!.login_btn,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20.h,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
