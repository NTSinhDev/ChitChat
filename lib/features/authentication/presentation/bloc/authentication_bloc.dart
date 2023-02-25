import 'package:chat_app/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:chat_app/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:chat_app/features/authentication/domain/services/authentication_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../personal/domain/entity/profile.dart';
import '../../../personal/domain/usecases/usecases.dart';
import '../../domain/usecases/usecases.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final SharedPreferences sharedPref;
  final authenticationServices = AuthenticationServices.getInstance();
  Profile? profile;

  AuthenticationBloc(this.sharedPref) : super(LoginState(loading: false)) {
    on<NormalLoginEvent>(_normalLogin);
    on<RegisterEvent>(_registerEvent);
    on<CheckAuthenticationEvent>(_checkAuthEvent);
    on<GoogleLoginEvent>(_googleLogin);
    on<LogoutEvent>(_logoutEvent);
    on<InitRegisterEvent>((event, emit) => emit(RegisterState(loading: false)));
    on<InitLoginEvent>((event, emit) => emit(LoginState(loading: false)));
    on<FacebookLoginEvent>((event, emit) {});
  }

  _checkAuthEvent(
    CheckAuthenticationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));


    profile = await GetAuthProfileAtLocalStorage().get(userID: event.userID);
    if(profile == null) return emit(LoginState(loading: false));

    emit(LoginState(loading: false));
    emit(LoggedState(
      loading: false,
      profile: profile,
      // authUser: _authUser,
      // chatRooms: _authUser!.chatRooms,
      // friendRequests: _authUser!.friendRequests,
      // listFriend: _authUser!.listFriend,
    ));
  }

  _googleLogin(
      GoogleLoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(LoginState(loading: true));

    final authUser = await authenticationServices.signInWithGoogle();

    if (authUser == null) {
      return emit(LoginState(
          loading: false)); // TODO: hiển thị thông báo đăng nhập thất bại
    }

    profile = await GetUserProfile().getProfile(userID: authUser.uid) ??
        await CreateNewUserProfile().create(authUser: authUser);

    await _storageData();

    emit(LoginState(loading: false));
    emit(LoggedState(loading: false, profile: profile));
  }

  Future<void> _storageData() async {
    await SaveUIDToLocal(sharedPref: sharedPref).save(profile!.id!);
    await SaveToProfileBox().save(profile: profile!);
  }

  _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    // emit(LoggedState(loading: true));
    final isLogout = await Logout(sharedPref: sharedPref).logout();
    if (!isLogout) return emit(LoggedState(loading: false));
    // emit(LoggedState(loading: false));
    emit(LoginState(loading: false));
  }

  _registerEvent(RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(RegisterState(loading: true));

    emit(RegisterState(loading: false));
    emit(LoggedState(
      loading: false,
      // authUser: _authUser,
      // chatRooms: _authUser!.chatRooms,
      // friendRequests: _authUser!.friendRequests,
      // listFriend: _authUser!.listFriend,
    ));
  }

  _normalLogin(NormalLoginEvent event, Emitter<AuthenticationState> emit) {}
}
