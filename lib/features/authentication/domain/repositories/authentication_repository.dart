import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationRepository {
  final SharedPreferences sharedPreferences;

  AuthenticationRepository(this.sharedPreferences);
  
  Future<String>? loginWithGoogleAccount();
  
  Future<void> saveUIdToLocal(String uid);
  
  Future<bool> logout();
}
