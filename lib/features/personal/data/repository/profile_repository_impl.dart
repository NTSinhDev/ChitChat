import 'dart:developer';

import 'package:chat_app/features/personal/data/datasources/profile_local_datasource.dart';
import 'package:chat_app/features/personal/data/datasources/profile_remote_datasource.dart';
import 'package:chat_app/features/personal/data/models/profile_model.dart';
import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/profile.dart';

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

      final profile =
          await _profileRemoteDataSource.getProfileById(userID: authUser.uid);

      if (profile == null) return null;
      return Profile(
        id: profile.id,
        email: profile.email,
        fullName: profile.fullName,
        messagingToken: profile.messagingToken,
      );
    } catch (_) {
      log('🚀log⚡ Error when get info user');
      return null;
    }
  }

  @override
  Future<Profile?> getUserProfile({required String? userID}) async {
    if (userID == null) return null;

    try {
      final profile =
          await _profileRemoteDataSource.getProfileById(userID: userID);

      if (profile == null) return null;
      return Profile(
        id: profile.id,
        email: profile.email,
        fullName: profile.fullName,
        messagingToken: profile.messagingToken,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveToProfileBox({required Profile profile}) async {
    await _checkInitLocalDataSource();

    try {
      final profileModel = ProfileModel(
        id: profile.id,
        email: profile.email,
        fullName: profile.fullName,
        messagingToken: profile.messagingToken,
      );
      await _profileLocalDataSource!.saveToProfileBox(profileModel);
    }
    // ignore: empty_catches
    catch (e) {}
  }

  getFile() {}

  @override
  Future<Profile?> getProfileAtLocalStorage({required String userID}) async {
    await _checkInitLocalDataSource();

    final profileModel = _profileLocalDataSource!.getProfileModel(userID);
    if (profileModel == null) return null;
    return Profile(
      email: profileModel.email,
      fullName: profileModel.fullName,
      id: profileModel.id,
      messagingToken: profileModel.messagingToken,
    );
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
