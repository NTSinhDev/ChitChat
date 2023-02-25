import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:chat_app/datasources/auth_local_datasource.dart';
import 'package:chat_app/datasources/profile_remote_datasource.dart';
import 'package:chat_app/services/authentication_services.dart';

abstract class AuthenticationRepository {
  final SharedPreferences sharedPreferences;
  AuthenticationRepository(this.sharedPreferences);
  Future<String>? loginWithGoogleAccount();
  Future<void> saveUIdToLocal(String uid);
  Future<bool> logout();
  String getUIDAtLocalStorage();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  late final AuthLocalDataSource localDataSource;
  late final ProfileRemoteDataSource remoteDataSource;
  final AuthenticationServices _authenticationServices =
      AuthenticationServices.getInstance();

  AuthenticationRepositoryImpl(SharedPreferences sharedPreferences)
      : super(sharedPreferences) {
    localDataSource = AuthLocalDataSource(sharedPreferences: sharedPreferences);
    remoteDataSource = ProfileRemoteDataSource();
  }

  @override
  Future<String> loginWithGoogleAccount() async {
    try {
      final authUser = await _authenticationServices.signInWithGoogle();
      if (authUser == null) return '';
      // save token
      await localDataSource.saveUIDToLocal(authUser.uid);
      return authUser.uid;
    } catch (e) {
      log('🚀Error: $e');
      return '';
    }
  }

  @override
  Future<bool> logout() async {
    final isLogout = await _authenticationServices.logout();
    if (isLogout) {
      localDataSource.removeUID();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> saveUIdToLocal(String uid) async {
    await localDataSource.saveUIDToLocal(uid);
  }
  
  @override
  String getUIDAtLocalStorage() {
    return localDataSource.getUID() ?? '';
  }
}