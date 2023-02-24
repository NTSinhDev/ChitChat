import 'package:chat_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:chat_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithGoogle {
  late final AuthenticationRepository _repository;

  LoginWithGoogle({required SharedPreferences sharedPreferences}) {
    _repository = AuthenticationRepositoryImpl(sharedPreferences);
  }

  Future<void> login() async => await _repository.loginWithGoogleAccount();
}
