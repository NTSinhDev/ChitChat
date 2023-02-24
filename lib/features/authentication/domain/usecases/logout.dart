import 'package:chat_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:chat_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout {
  late final AuthenticationRepository _repository;

  Logout({required SharedPreferences sharedPreferences}) {
    _repository = AuthenticationRepositoryImpl(sharedPreferences);
  }

  Future<bool> logout() async => await _repository.logout();
}
