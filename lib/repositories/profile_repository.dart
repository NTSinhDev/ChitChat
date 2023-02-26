import 'dart:developer';

import 'package:chat_app/datasources/remote_datasources/profile_remote_datasource.dart';
import 'package:chat_app/models/profile.dart';
import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/local_datasources/injector.dart';

abstract class ProfileRepository {
  Future<Profile?> createUserProfile({required User? authUser});
  Future<Profile?> getUserProfile({required String? userID});
  Future<void> saveToProfileBox({required Profile? profile});
  Future<UserProfile?> getProfileAtLocalStorage({required String userID});
}

class ProfileRepositoryImpl implements ProfileRepository {
  late final ProfileRemoteDataSource _profileRemoteDataSource;
  late final StorageLocalDataSource _storageLocalDataSource;

  ProfileLocalDataSource? _profileLocalDataSource;
  bool isInitLocalDataSource = false;

  ProfileRepositoryImpl() {
    _profileRemoteDataSource = ProfileRemoteDataSourceImpl();
    _storageLocalDataSource = StorageLocalDataSourceImpl();
  }

  Future initLocalDataSource() async {
    try {
      _profileLocalDataSource = ProfileLocalDataSourceImpl();

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
  Future<void> saveToProfileBox({required Profile? profile}) async {
    if (profile == null) return;

    await _checkInitLocalDataSource();
    try {
      await _profileLocalDataSource!.saveToProfileBox(profile);
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Future<UserProfile?> getProfileAtLocalStorage({
    required String userID,
  }) async {
    await _checkInitLocalDataSource();

    try {
      final Profile? profile = _profileLocalDataSource!.getProfile(userID);
      final url = await _storageLocalDataSource.getFile(fileName: userID);
      final urlImage = URLImage(url: url, type: TypeImage.local);
      return UserProfile(urlImage: urlImage, profile: profile);
    } catch (e) {
      log('🚀log⚡ error get profile at local: $e');
      return null;
    }
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
