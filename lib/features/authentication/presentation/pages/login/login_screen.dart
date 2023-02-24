import 'package:chat_app/my_task.dart';
import 'package:chat_app/presentation/helper/loading/loading_screen.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/components/signin_other_ways.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/components/signin_title.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/components/forgot_password_btn.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/components/signup_btn.dart';
import 'package:chat_app/features/authentication/presentation/pages/login/components/social_btn_row.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/res/style.dart';
import 'package:chat_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/utils/functions.dart';
import 'package:chat_app/presentation/widgets/input_text_field.dart';
import 'package:chat_app/presentation/widgets/large_round_button.dart';
import 'package:chat_app/presentation/widgets/warning_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final String deviceToken;
  const LoginScreen({super.key, required this.deviceToken});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  String _messagePassword = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LoginState) {
          if (state.loading) {
            LoadingScreen().show(context: context);
          } else {
            LoadingScreen().hide();
          }
          if (state.message != null) {
            showToast(state.message ??
                AppLocalizations.of(context)!.cannot_connect_to_server);
          }
        }
      },
      child: Scaffold(
        backgroundColor: deepPurple,
        body: InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: paddingAuthLG,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: boxBGAuth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SignInTitle(),
                  SizedBox(height: 40.h),
                  InputTextField(
                    title: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.enter_your_email,
                    icon: Icons.email,
                    keyInput: 'email',
                    obscure: false,
                    type: TextInputType.emailAddress,
                    // onSubmitted: (value) {},
                    onChanged: (email) => _formatEmail(email),
                  ),
                  WarningMessage(
                    isDataValid: _isValidEmail,
                    message: AppLocalizations.of(context)!.required_email,
                  ),
                  SizedBox(height: 20.h),
                  InputTextField(
                    title: AppLocalizations.of(context)!.password,
                    hint: AppLocalizations.of(context)!.enter_your_password,
                    icon: Icons.lock,
                    keyInput: 'password',
                    obscure: true,
                    type: TextInputType.multiline,
                    // onSubmitted: (value) {},
                    onChanged: (password) => _formatPassword(password),
                  ),
                  WarningMessage(
                    isDataValid: _isValidPassword,
                    message: _messagePassword,
                  ),
                  const ForgotPasswordBtn(),
                  LargeRoundButton(
                    textButton: AppLocalizations.of(context)!.login_btn,
                    onTap: _loginApp,
                  ),
                  const SignInOtherWays(),
                  const SocialBtnRow(),
                  const SignupBtn(),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MytaskScreen(),
                      ),
                    ),
                    child: Text(
                      'My Task',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loginApp() {
    if (_isValidPassword || _isValidEmail) return;
    context.read<AuthenticationBloc>().add(
          NormalLoginEvent(
            email: _email,
            password: _password,
            deviceToken: widget.deviceToken,
          ),
        );
  }

  _formatPassword(String password) {
    if (password.isEmpty) {
      setState(() {
        _isValidPassword = true;
        _messagePassword = AppLocalizations.of(context)!.required_password;
      });
    } else if (password.length < 6) {
      setState(() {
        _isValidPassword = true;
        _messagePassword = AppLocalizations.of(context)!.more_than_5_charac;
      });
    } else {
      setState(() {
        _isValidPassword = false;
        _password = password;
      });
    }
  }

  _formatEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        _isValidEmail = true;
      });
    } else {
      setState(() {
        _isValidEmail = false;
        _email = email;
      });
    }
  }
}
