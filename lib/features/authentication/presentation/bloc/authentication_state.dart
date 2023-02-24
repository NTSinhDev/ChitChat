import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/features/personal/data/models/profile.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthLoadingState extends AuthenticationState {}

class RegisterState extends AuthenticationState {
  final String? message;
  final bool loading;
  RegisterState({
    required this.loading,
    this.message,
  });
}

class LoginState extends AuthenticationState {
  bool loading;
  String? message;
  LoginState({
    required this.loading,
    this.message,
  });
}

class LoggedState extends AuthenticationState {
  final Profile? profile;
  final List<dynamic>? chatRooms;
  final List<dynamic>? friendRequests;
  final List<dynamic>? listFriend;
  final bool loading;
  LoggedState({
    this.profile,
    this.chatRooms,
    this.friendRequests,
    this.listFriend,
    required this.loading,
  });
}
