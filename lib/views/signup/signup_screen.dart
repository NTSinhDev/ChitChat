import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/signup/components/signin_btn.dart';
import 'package:chat_app/res/styles.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is RegisterState) {
          if (state.message != null) {
            FlashMessageWidget(
              context: context,
              message: state.message!,
              type: FlashMessageType.error,
            );
          }
          if (state.loading) {
            LoadingScreenWidget().show(context: context);
          } else {
            LoadingScreenWidget().hide();
          }
        }
      },
      child: Scaffold(
        body: InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: ResDecorate.paddingAuthRG,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: ResDecorate.boxBGAuth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSignUpTitle(context),
                  Spaces.h16,
                  InputTextField(
                    title: context.languagesExtension.name,
                    hint: context.languagesExtension.enter_your_name,
                    icon: CupertinoIcons.person,
                    keyInput: 'name',
                    obscure: false,
                    type: TextInputType.name,
                    onSubmitted: null,
                    onChanged: (name) => _formatName(name),
                  ),
                  WarningMessage(
                    isDataValid: _isValidEmail,
                    message: context.languagesExtension.required_name,
                  ),
                  Spaces.h16,
                  InputTextField(
                    title: context.languagesExtension.email,
                    hint: context.languagesExtension.enter_your_email,
                    icon: Icons.email,
                    keyInput: 'email',
                    obscure: false,
                    type: TextInputType.emailAddress,
                    onSubmitted: null,
                    onChanged: (email) => _formatEmail(email),
                  ),
                  WarningMessage(
                    isDataValid: _isValidEmail,
                    message: context.languagesExtension.required_email,
                  ),
                  Spaces.h16,
                  InputTextField(
                    title: context.languagesExtension.password,
                    hint: context.languagesExtension.enter_your_password,
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
                  Spaces.h16,
                  InputTextField(
                    title: context.languagesExtension.verify,
                    hint: context.languagesExtension.re_enter_your_password,
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
                  Spaces.h16,
                  LargeRoundButton(
                    textButton: context.languagesExtension.register,
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
      context.languagesExtension.register,
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
        _messagePassword = context.languagesExtension.required_password;
      });
    } else if (password.length < 6) {
      setState(() {
        _isValidPassword = true;
        _messagePassword = context.languagesExtension.more_than_5_charac;
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
        _messageVerified = context.languagesExtension.warn_password_first;
      });
    } else if (_password != password) {
      setState(() {
        _isValidVerified = true;
        _messageVerified = context.languagesExtension.warn_password_match;
      });
    } else {
      setState(() {
        _isValidVerified = false;
      });
    }
  }
}
