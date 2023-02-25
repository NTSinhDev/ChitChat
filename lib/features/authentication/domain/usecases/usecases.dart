import 'package:chat_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/features/authentication/domain/repositories/authentication_repository.dart';

class GetUIDAtLocalStorage extends BaseUsecase {
  late String userID;
  GetUIDAtLocalStorage({required super.sharedPref}) {
    userID = repository.getUIDAtLocalStorage();
  }
}

class LoginWithGoogle extends BaseUsecase {
  late final AuthenticationRepository _repository;
  LoginWithGoogle({required super.sharedPref});
  Future<void> login() async => await _repository.loginWithGoogleAccount();
}

class Logout extends BaseUsecase {
  Logout({required super.sharedPref});
  Future<bool> logout() async => await repository.logout();
}

class SaveUIDToLocal extends BaseUsecase {
  SaveUIDToLocal({required super.sharedPref});
  Future<void> save(String uid) async => await repository.saveUIdToLocal(uid);
}

abstract class BaseUsecase {
  late final AuthenticationRepository repository;
  BaseUsecase({required SharedPreferences sharedPref}) {
    repository = AuthenticationRepositoryImpl(sharedPref);
  }
}
