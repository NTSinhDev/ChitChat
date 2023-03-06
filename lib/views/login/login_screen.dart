import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/login/components/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final String deviceToken;
  const LoginScreen({super.key, required this.deviceToken});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool isValidEmail = false;
  bool isValidPassword = false;
  String messagePassword = "";

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
            FlashMessage(
              context: context,
              message: state.message!,
              type: FlashMessageType.error,
            );
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
                  Spaces.h40,
                  InputTextField(
                    title: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.enter_your_email,
                    icon: Icons.email,
                    keyInput: 'email',
                    obscure: false,
                    type: TextInputType.emailAddress,
                    // onSubmitted: (value) {},
                    onChanged: (email) => formatEmail(email),
                  ),
                  WarningMessage(
                    isDataValid: isValidEmail,
                    message: AppLocalizations.of(context)!.required_email,
                  ),
                  Spaces.h20,
                  InputTextField(
                    title: AppLocalizations.of(context)!.password,
                    hint: AppLocalizations.of(context)!.enter_your_password,
                    icon: Icons.lock,
                    keyInput: 'password',
                    obscure: true,
                    type: TextInputType.multiline,
                    // onSubmitted: (value) {},
                    onChanged: (password) => formatPassword(password),
                  ),
                  WarningMessage(
                    isDataValid: isValidPassword,
                    message: messagePassword,
                  ),
                  const ForgotPasswordBtn(),
                  LargeRoundButton(
                    textButton: AppLocalizations.of(context)!.login_btn,
                    onTap: loginApp,
                  ),
                  const SignInOtherWays(),
                  const SocialBtnRow(),
                  const SignupBtn(),
                  Spaces.h12,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginApp() {
    if (isValidPassword || isValidEmail) return;
    context.read<AuthenticationBloc>().add(
          NormalLoginEvent(
            email: email,
            password: password,
            deviceToken: widget.deviceToken,
          ),
        );
  }

  formatPassword(String password) {
    if (password.isEmpty) {
      setState(() {
        isValidPassword = true;
        messagePassword = AppLocalizations.of(context)!.required_password;
      });
    } else if (password.length < 6) {
      setState(() {
        isValidPassword = true;
        messagePassword = AppLocalizations.of(context)!.more_than_5_charac;
      });
    } else {
      setState(() {
        isValidPassword = false;
        password = password;
      });
    }
  }

  formatEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        isValidEmail = true;
      });
    } else {
      setState(() {
        isValidEmail = false;
        email = email;
      });
    }
  }
}
