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

class InitRegisterEvent extends AuthenticationEvent {}

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

class InitLoginEvent extends AuthenticationEvent {}

class LoginByAccessTokenEvent extends AuthenticationEvent {}

class GoogleLoginEvent extends AuthenticationEvent {}

class FacebookLoginEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
