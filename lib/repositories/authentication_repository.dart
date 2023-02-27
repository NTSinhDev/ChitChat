import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/models/profile.dart';
import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:chat_app/datasources/local_datasources/auth_local_datasource.dart';
import 'package:chat_app/datasources/remote_datasources/profile_remote_datasource.dart';
import 'package:chat_app/services/authentication_services.dart';

abstract class AuthenticationRepository {
  Future<UserProfile?> loginWithGoogleAccount();
  Future<bool> logout();
  Future<void> saveUIdToLocal({required UserProfile? userProfile});
  String? getUIDAtLocalStorage();
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationServices _authenticationServices =
      AuthenticationServices.getInstance();

  late final AuthLocalDataSource _authLocalDataSource;
  late final ProfileRemoteDataSource _profileRemoteDataSource;

  AuthenticationRepositoryImpl(SharedPreferences sharedPreferences) {
    _authLocalDataSource = AuthLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    _profileRemoteDataSource = ProfileRemoteDataSourceImpl();
  }

  @override
  Future<UserProfile?> loginWithGoogleAccount() async {
    try {
      UserProfile? userProfile;
      // authenticate
      final authUser = await _authenticationServices.signInWithGoogle();
      if (authUser == null) return null;

      // get information of this account
      final String? urlImage = await _profileRemoteDataSource.getFile(
            filePath: StorageKey.pPROFILE,
            fileName: authUser.uid,
          ) ??
          await _profileRemoteDataSource.uploadFile(
            url: authUser.photoURL!,
            filePath: StorageKey.pPROFILE,
            fileName: authUser.uid,
          );

      final Profile? profile = await _profileRemoteDataSource.getProfileById(
            userID: authUser.uid,
          ) ??
          await _profileRemoteDataSource.createProfile(
            authUser: authUser,
          );

      userProfile = UserProfile(
        profile: profile,
        urlImage: URLImage(url: urlImage, type: TypeImage.remote),
      );
      return userProfile;
    } catch (e) {
      log('🚀Error: $e');
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    final isLogout = await _authenticationServices.logout();
    if (isLogout) {
      _authLocalDataSource.removeUID();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> saveUIdToLocal({required UserProfile? userProfile}) async {
    if (userProfile == null ||
        userProfile.profile == null ||
        userProfile.profile?.id == null) return;
    await _authLocalDataSource.saveUIDToLocal(userProfile.profile!.id!);
  }

  @override
  String? getUIDAtLocalStorage() => _authLocalDataSource.getUID();
}
