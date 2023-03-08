import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignupBtn extends StatelessWidget {
  const SignupBtn({super.key});

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
              AppLocalizations.of(context)!.donot_have_an_account,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spaces.w8,
          InkWell(
            onTap: () =>
                context.read<AuthenticationBloc>().add(InitRegisterEvent()),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.w),
              child: Text(
                AppLocalizations.of(context)!.register,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20.h,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
