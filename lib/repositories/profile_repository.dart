import 'dart:developer';

import 'package:chat_app/datasources/profile_local_datasource.dart';
import 'package:chat_app/datasources/profile_remote_datasource.dart';
import 'package:chat_app/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileRepository {
  Future<Profile?> createUserProfile({required User? authUser});
  Future<Profile?> getUserProfile({required String? userID});
  Future<void> saveToProfileBox({required Profile profile});
  Future<Profile?> getProfileAtLocalStorage({required String userID});
}

class ProfileRepositoryImpl extends ProfileRepository {
  late final ProfileRemoteDataSource _profileRemoteDataSource;
  ProfileLocalDataSource? _profileLocalDataSource;

  ProfileRepositoryImpl() {
    _profileRemoteDataSource = ProfileRemoteDataSource();
  }

  bool isInitLocalDataSource = false;
  Future initLocalDataSource() async {
    try {
      _profileLocalDataSource = ProfileLocalDataSource();

      final box = await _profileLocalDataSource!
          .openBox()
          .timeout(const Duration(seconds: 10));

      isInitLocalDataSource = box == null ? false : true;
    } catch (e) {
      isInitLocalDataSource = false;
    }
  }

  @override
  Future<Profile?> createUserProfile({required User? authUser}) async {
    if (authUser == null || authUser.uid.isEmpty) return null;

    try {
      await _profileRemoteDataSource.createProfile(authUser: authUser);

      return await _profileRemoteDataSource.getProfileById(
          userID: authUser.uid);
    } catch (_) {
      log('🚀log⚡ Error when get info user');
      return null;
    }
  }

  @override
  Future<Profile?> getUserProfile({required String? userID}) async {
    if (userID == null) return null;
    try {
      return await _profileRemoteDataSource.getProfileById(userID: userID);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveToProfileBox({required Profile profile}) async {
    await _checkInitLocalDataSource();
    try {
      await _profileLocalDataSource!.saveToProfileBox(profile);
    }
    // ignore: empty_catches
    catch (e) {}
  }

  getFile() {}

  @override
  Future<Profile?> getProfileAtLocalStorage({required String userID}) async {
    await _checkInitLocalDataSource();
    return _profileLocalDataSource!.getProfile(userID);
  }

  Future _checkInitLocalDataSource() async {
    int i = 0;
    do {
      if (i != 0) {
        await initLocalDataSource();
      }
      i++;
    } while (!isInitLocalDataSource);
  }
}
