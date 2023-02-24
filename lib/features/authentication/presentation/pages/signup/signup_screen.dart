import 'package:chat_app/presentation/helper/loading/loading_screen.dart';
import 'package:chat_app/presentation/helper/notify/alert_error.dart';
import 'package:chat_app/features/authentication/presentation/pages/signup/components/signin_btn.dart';
import 'package:chat_app/presentation/res/style.dart';
import 'package:chat_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/widgets/input_text_field.dart';
import 'package:chat_app/presentation/widgets/large_round_button.dart';
import 'package:chat_app/presentation/widgets/warning_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _name = "";
  String _email = "";
  String _password = "";
  bool _isValidName = false;
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidVerified = false;
  String _messagePassword = "";
  String _messageVerified = "";
  @override
  Widget build(BuildContext context) {
    var sizedBox16 = SizedBox(height: 16.h);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is RegisterState) {
          if (state.message != null) {
            showDialog(
              context: context,
              builder: (context) => AlertError(
                title: "error",
                content: state.message ?? 'Cannot connect to server',
                nameBtn: 'Oke',
              ),
            );
          }
          if (state.loading) {
            LoadingScreen().show(context: context);
          } else {
            LoadingScreen().hide();
          }
        }
      },
      child: Scaffold(
        body: InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: paddingAuthRG,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: boxBGAuth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSignUpTitle(context),
                  sizedBox16,
                  InputTextField(
                    title: AppLocalizations.of(context)!.name,
                    hint: AppLocalizations.of(context)!.enter_your_name,
                    icon: CupertinoIcons.person,
                    keyInput: 'name',
                    obscure: false,
                    type: TextInputType.name,
                    onSubmitted: null,
                    onChanged: (name) => _formatName(name),
                  ),
                  WarningMessage(
                    isDataValid: _isValidEmail,
                    message: AppLocalizations.of(context)!.required_name,
                  ),
                  sizedBox16,
                  InputTextField(
                    title: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.enter_your_email,
                    icon: Icons.email,
                    keyInput: 'email',
                    obscure: false,
                    type: TextInputType.emailAddress,
                    onSubmitted: null,
                    onChanged: (email) => _formatEmail(email),
                  ),
                  WarningMessage(
                    isDataValid: _isValidEmail,
                    message: AppLocalizations.of(context)!.required_email,
                  ),
                  sizedBox16,
                  InputTextField(
                    title: AppLocalizations.of(context)!.password,
                    hint: AppLocalizations.of(context)!.enter_your_password,
                    icon: Icons.lock,
                    keyInput: 'password',
                    obscure: true,
                    type: TextInputType.multiline,
                    onSubmitted: null,
                    onChanged: (password) => _formatPassword(password),
                  ),
                  WarningMessage(
                    isDataValid: _isValidPassword,
                    message: _messagePassword,
                  ),
                  sizedBox16,
                  InputTextField(
                    title: AppLocalizations.of(context)!.verify,
                    hint: AppLocalizations.of(context)!.re_enter_your_password,
                    icon: Icons.verified_user_outlined,
                    keyInput: 'password',
                    obscure: true,
                    type: TextInputType.multiline,
                    onSubmitted: null,
                    onChanged: (password) => _verifyPassword(password),
                  ),
                  WarningMessage(
                    isDataValid: _isValidVerified,
                    message: _messageVerified,
                  ),
                  sizedBox16,
                  LargeRoundButton(
                    textButton: AppLocalizations.of(context)!.register,
                    onTap: () => _signupApp(context),
                  ),
                  const SignInBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signupApp(BuildContext context) {
    if (_isValidName || _isValidEmail || _isValidPassword || _isValidVerified) {
      return;
    }
    context.read<AuthenticationBloc>().add(
          RegisterEvent(
            name: _name,
            email: _email,
            password: _password,
          ),
        );
  }

  Text _buildSignUpTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.register,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: Colors.white70,
            fontSize: 30.h,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  _formatName(String name) {
    if (name.isEmpty) {
      setState(() {
        _isValidName = true;
      });
    } else {
      setState(() {
        _isValidName = false;
        _name = name;
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

  _verifyPassword(String password) {
    if (_password.isEmpty) {
      setState(() {
        _isValidVerified = true;
        _messageVerified = AppLocalizations.of(context)!.warn_password_first;
      });
    } else if (_password != password) {
      setState(() {
        _isValidVerified = true;
        _messageVerified = AppLocalizations.of(context)!.warn_password_match;
      });
    } else {
      setState(() {
        _isValidVerified = false;
      });
    }
  }
}
