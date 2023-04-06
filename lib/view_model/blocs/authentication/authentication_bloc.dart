import 'dart:developer';

import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/data/repositories/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/services/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authenticationServices = AuthenticationServices.getInstance();

  final SharedPreferences sharedPref;
  late final UserInformationRepository _userInforRepository;
  late final AuthenticationRepository _authenticationRepository;

  UserProfile? userProfile;

  AuthenticationBloc(this.sharedPref) : super(LoginState(loading: false)) {
    _authenticationRepository = AuthenticationRepositoryImpl(sharedPref);
    _userInforRepository = UserInformationRepository();
    on<NormalLoginEvent>(_normalLogin);
    on<RegisterEvent>(_registerEvent);
    on<CheckAuthenticationEvent>(_checkAuthEvent);
    on<GoogleLoginEvent>(_googleLogin);
    on<LogoutEvent>(_logoutEvent);
    on<InitRegisterEvent>((event, emit) => emit(RegisterState(loading: false)));
    on<InitLoginEvent>((event, emit) => emit(LoginState(loading: false)));
    on<UpdateAuthInfoEvent>(_updateAuthInfo);
  }

  _updateAuthInfo(
    UpdateAuthInfoEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    if (event.userProfile.profile == null ||
        event.userProfile.urlImage.url == null) {
      return;
    }
    userProfile = event.userProfile;
    emit(LoggedState(userProfile: userProfile!, loading: false));
  }

  _checkAuthEvent(
    CheckAuthenticationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    log('🚀_checkAuthEvent⚡ start');
    emit(LoginState(loading: true));

    userProfile = await _userInforRepository.local.getProfile(
      userID: event.userID,
    );
    log('🚀_checkAuthEvent⚡ $userProfile');

    if (userProfile == null) return emit(LoginState(loading: false));
    final catchError = await _userInforRepository.remote
        .updatePresence(id: userProfile!.profile!.id!);
    if (catchError != null) {
      return emit(LoginState(loading: false, message: catchError));
    }

    emit(LoginState(loading: false));
    emit(LoggedState(
      loading: false,
      userProfile: userProfile!,
    ));
    log('🚀_checkAuthEvent⚡ success');
  }

  _googleLogin(
    GoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));

    userProfile = await _authenticationRepository.loginWithGoogleAccount();

    if (userProfile == null || userProfile?.profile == null) {
      return emit(LoginState(loading: false, message: "Đăng nhập thất bại"));
    }

    emit(LoginState(loading: false));
    emit(LoggedState(loading: false, userProfile: userProfile!));
    await _storageData();
  }

  Future<void> _storageData() async {
    await _authenticationRepository.saveUIdToLocal(userProfile: userProfile);
    await _userInforRepository.local.saveProfile(profile: userProfile!.profile);
    await _userInforRepository.local.saveImageFile(userProfile: userProfile);
  }

  _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    final isLogout = await _authenticationRepository.logout();
    // if (!isLogout) {
    //   return emit(LoggedState(
    //     loading: false,
    //     userProfile: userProfile!,
    //   ));
    // }

    emit(LoginState(loading: false));
  }

  _registerEvent(
      RegisterEvent event, Emitter<AuthenticationState> emit) async {}

  _normalLogin(NormalLoginEvent event, Emitter<AuthenticationState> emit) {}
}
