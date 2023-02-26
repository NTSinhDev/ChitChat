import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/repositories/injector.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_event.dart';
import 'package:chat_app/view_model/blocs/authentication/authentication_state.dart';
import 'package:chat_app/services/authentication_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authenticationServices = AuthenticationServices.getInstance();
  UserProfile? userProfile;

  final SharedPreferences sharedPref;
  final ProfileRepository _profileRepository = ProfileRepositoryImpl();
  final StorageRepository _storageRepository = StorageRepositoryImpl();
  late final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this.sharedPref) : super(LoginState(loading: false)) {
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

    userProfile = await _profileRepository.getProfileAtLocalStorage(
      userID: event.userID,
    );

    if (userProfile == null) return emit(LoginState(loading: false));

    emit(LoginState(loading: false));
    emit(LoggedState(
      loading: false,
      userProfile: userProfile!,
    ));
  }

  _googleLogin(
    GoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));

    userProfile = await _authenticationRepository.loginWithGoogleAccount();

    if (userProfile == null || userProfile?.profile == null) {
      return emit(LoginState(
          loading: false)); // TODO: hiển thị thông báo đăng nhập thất bại
    }

    emit(LoginState(loading: false));
    emit(LoggedState(loading: false, userProfile: userProfile!));
    await _storageData();
  }

  Future<void> _storageData() async {
    await _authenticationRepository.saveUIdToLocal(userProfile: userProfile);
    await _profileRepository.saveToProfileBox(profile: userProfile!.profile);
    await _storageRepository.saveFileToStorage(userProfile: userProfile);
  }

  _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    final isLogout = await _authenticationRepository.logout();
    if (!isLogout) {
      return emit(LoggedState(
        loading: false,
        userProfile: userProfile!,
      ));
    }

    emit(LoginState(loading: false));
  }

  _registerEvent(
      RegisterEvent event, Emitter<AuthenticationState> emit) async {}

  _normalLogin(NormalLoginEvent event, Emitter<AuthenticationState> emit) {}
}
