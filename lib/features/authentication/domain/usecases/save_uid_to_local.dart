import 'package:chat_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:chat_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUIDToLocal {
  late final AuthenticationRepository _repository;

  SaveUIDToLocal({required SharedPreferences sharedPreferences}) {
    _repository = AuthenticationRepositoryImpl(sharedPreferences);
  }

  Future<void> save(String uid) async => await _repository.saveUIdToLocal(uid);
}
