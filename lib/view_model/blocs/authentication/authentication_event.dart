import 'package:chat_app/models/user_profile.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class RegisterEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class NormalLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String deviceToken;
  NormalLoginEvent({
    required this.email,
    required this.password,
    required this.deviceToken,
  });
}

class CheckAuthenticationEvent extends AuthenticationEvent {
  final String userID;
  CheckAuthenticationEvent({required this.userID});
}

class InitLoginEvent extends AuthenticationEvent {}

class InitRegisterEvent extends AuthenticationEvent {}

class GoogleLoginEvent extends AuthenticationEvent {}

class FacebookLoginEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}

class UpdateAuthInfoEvent extends AuthenticationEvent {
  final UserProfile userProfile;
  UpdateAuthInfoEvent({
    required this.userProfile,
  });
}
