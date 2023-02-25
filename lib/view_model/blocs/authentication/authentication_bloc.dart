import 'package:chat_app/models/profile.dart';
import 'package:chat_app/repositories/authentication_repository.dart';
import 'package:chat_app/repositories/profile_repository.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_event.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_state.dart';
import 'package:chat_app/services/authentication_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  Profile? profile;

  final authenticationServices = AuthenticationServices.getInstance();

  final SharedPreferences sharedPref;

  late final ProfileRepository _profileRepository;
  late final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this.sharedPref) : super(LoginState(loading: false)) {
    _profileRepository = ProfileRepositoryImpl();
    _authenticationRepository = AuthenticationRepositoryImpl(sharedPref);
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

    profile =
        await _profileRepository.getProfileAtLocalStorage(userID: event.userID);
    if (profile == null) return emit(LoginState(loading: false));

    emit(LoginState(loading: false));
    emit(LoggedState(
      loading: false,
      profile: profile,
    ));
  }

  _googleLogin(
    GoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));

    final authUser = await authenticationServices.signInWithGoogle();

    if (authUser == null) {
      return emit(LoginState(
          loading: false)); // TODO: hiển thị thông báo đăng nhập thất bại
    }

    profile = await _profileRepository.getUserProfile(userID: authUser.uid) ??
        await _profileRepository.createUserProfile(authUser: authUser);

    await _storageData();

    emit(LoginState(loading: false));
    emit(LoggedState(loading: false, profile: profile));
  }

  Future<void> _storageData() async {
    await _authenticationRepository.saveUIdToLocal(profile!.id!);
    await _profileRepository.saveToProfileBox(profile: profile!);
  }

  _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    final isLogout = await _authenticationRepository.logout();
    if (!isLogout) return emit(LoggedState(loading: false));
    emit(LoginState(loading: false));
  }

  _registerEvent(
      RegisterEvent event, Emitter<AuthenticationState> emit) async {}

  _normalLogin(NormalLoginEvent event, Emitter<AuthenticationState> emit) {}
}
