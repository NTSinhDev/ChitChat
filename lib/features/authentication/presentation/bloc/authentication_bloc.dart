import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/data/repository/auth_repository.dart';
import 'package:chat_app/features/authentication/domain/usecases/logout.dart';
import 'package:chat_app/features/authentication/domain/usecases/save_uid_to_local.dart';
import 'package:chat_app/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:chat_app/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:chat_app/features/authentication/data/services/authentication_services.dart';
import 'package:chat_app/features/personal/data/models/profile.dart';
import 'package:chat_app/features/personal/domain/usecases/create_user_profile.dart';
import 'package:chat_app/features/personal/domain/usecases/get_user_profile.dart';
import 'package:chat_app/features/personal/domain/usecases/open_profile_box.dart';
import 'package:chat_app/features/personal/domain/usecases/save_to_profile_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final AuthRepository authRepository;
  late final SharedPreferences sharedPreferences;
  late AuthUser? _authUser;

  // new
  final authenticationServices = AuthenticationServices.getInstance();
  Profile? profile;

  AuthenticationBloc(
    this.authRepository,
    this.sharedPreferences,
  ) : super(AuthLoadingState()) {
    on<NormalLoginEvent>(_normalLogin);
    on<InitLoginEvent>((event, emit) => emit(LoginState(loading: false)));
    on<RegisterEvent>(_registerEvent);
    on<LoginByAccessTokenEvent>(_loginByAccessToken);
    on<InitRegisterEvent>((event, emit) => emit(RegisterState(loading: false)));
    on<GoogleLoginEvent>(_loginWithGoogleAccount);
    on<FacebookLoginEvent>((event, emit) {});
    on<LogoutEvent>(_logoutEvent);
  }

  _loginWithGoogleAccount(
    GoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Show loading
    emit(LoginState(loading: true));
    // open profile box
    OpenProfileBox().open();
    // login with google account
    final authUser = await authenticationServices.signInWithGoogle();
    // Lấy id user từ authUser
    if (authUser == null) return emit(LoginState(loading: false));
    // get profile
    profile = await GetUserProfile().getProfile(userID: authUser.uid) ??
        await CreateNewUserProfile().create(authUser: authUser);
    // save data to local
    await SaveUIDToLocal(sharedPreferences: sharedPreferences)
        .save(profile!.id!);
    // put Profile into ProfileBox
    await SaveToProfileBox().save(profile: profile!);

    emit(LoginState(loading: false));

    emit(LoggedState(loading: false, profile: profile
        // authUser: _authUser,
        // chatRooms: _authUser!.chatRooms,
        // friendRequests: _authUser!.friendRequests,
        // listFriend: _authUser!.listFriend,
        ));
  }

  _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    // emit(LoggedState(loading: true));
    final isLogout =
        await Logout(sharedPreferences: sharedPreferences).logout();
    if (!isLogout) return emit(LoggedState(loading: false));
    // emit(LoggedState(loading: false));
    emit(LoginState(loading: false));
  }

  _registerEvent(RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(RegisterState(loading: true));

    final valueRegister = await authRepository.getDataRegister(
      data: {
        'name': event.name,
        'email': event.email,
        'password': event.password,
      },
      header: {'Content-Type': 'application/json'},
    );
    if (valueRegister == null) {
      return emit(RegisterState(loading: false));
    }
    if (valueRegister.result != 1) {
      return emit(RegisterState(
        message: valueRegister.error?.message,
        loading: false,
      ));
    }

    // Auto Login
    final valueLogin = await authRepository.getDataLogin(
      data: {'email': event.email, 'password': event.password},
      header: {'Content-Type': 'application/json'},
    );

    if (valueLogin == null || valueLogin.result != 1) {
      emit(RegisterState(loading: false));
      return emit(LoginState(loading: false));
    }

    _authUser = authRepository.convertDynamicToObject(valueLogin.data[0]);

    if (_authUser!.accessToken != null &&
        _authUser!.accessToken!.accessToken != null) {
      sharedPreferences.setString(
          'auth_token', _authUser!.accessToken!.accessToken ?? '');
    }

    emit(RegisterState(loading: false));
    emit(LoggedState(
      loading: false,
      // authUser: _authUser,
      // chatRooms: _authUser!.chatRooms,
      // friendRequests: _authUser!.friendRequests,
      // listFriend: _authUser!.listFriend,
    ));
  }

  _normalLogin(
    NormalLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));

    final value = await authRepository.getDataLogin(
      data: {
        'email': event.email,
        'password': event.password,
        'deviceToken': event.deviceToken,
      },
      header: {'Content-Type': 'application/json'},
    );

    if (value == null || value.result != 1) {
      return emit(LoginState(loading: false, message: 'Đăng nhập thất bại'));
    }

    _authUser = authRepository.convertDynamicToObject(value.data[0]);

    emit(LoginState(loading: false));

    emit(LoggedState(
      loading: false,
      // authUser: _authUser,
      // chatRooms: _authUser!.chatRooms,
      // friendRequests: _authUser!.friendRequests,
      // listFriend: _authUser!.listFriend,
    ));

    if (_authUser != null && _authUser?.accessToken != null) {
      final shared = sharedPreferences;
      shared.setString('auth_token', _authUser!.accessToken!.accessToken ?? '');
    }
  }

  _loginByAccessToken(
    LoginByAccessTokenEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(LoginState(loading: true));

    final shared = await sharedPreferences;
    final tokenUser = shared.getString('auth_token');

    if (tokenUser == null || tokenUser.isEmpty) {
      return emit(LoginState(loading: false));
    }

    final value = await authRepository.getDataLoginWithAccessToken(
      data: {},
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenUser'
      },
    );

    if (value == null || value.result != 1) {
      return emit(LoginState(loading: false));
    }
    _authUser = authRepository.convertDynamicToObject(value.data[0]);

    emit(LoginState(loading: false));
    emit(LoggedState(
      loading: false,
      // authUser: _authUser,
      // chatRooms: _authUser!.chatRooms,
      // friendRequests: _authUser!.friendRequests,
      // listFriend: _authUser!.listFriend,
    ));
  }
}
