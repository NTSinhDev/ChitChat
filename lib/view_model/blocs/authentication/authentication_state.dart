import 'package:chat_app/models/user_profile.dart';

abstract class AuthenticationState {
  final bool loading;
  final String messageLoading;

  AuthenticationState({
    required this.loading,
    this.messageLoading = '',
  });
}

class RegisterState extends AuthenticationState {
  final String? message;
  RegisterState({
    this.message,
    required super.loading,
  });
}

class LoginState extends AuthenticationState {
  String? message;
  LoginState({
    this.message,
    required super.loading,
  });
}

class LoggedState extends AuthenticationState {
  final UserProfile userProfile;
  final List<dynamic>? chatRooms;
  final List<dynamic>? friendRequests;
  final List<dynamic>? listFriend;
  LoggedState({
    required this.userProfile,
    this.chatRooms,
    this.friendRequests,
    this.listFriend,
    required super.loading,
  });
}
