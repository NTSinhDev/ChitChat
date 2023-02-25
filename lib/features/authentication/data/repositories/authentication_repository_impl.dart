// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chat_app/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:chat_app/features/personal/data/datasources/profile_remote_datasource.dart';
import 'package:chat_app/features/authentication/domain/services/authentication_services.dart';
import 'package:chat_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
