import 'dart:developer';

import 'package:chat_app/features/personal/data/datasources/profile_local_datasource.dart';
import 'package:chat_app/features/personal/data/datasources/profile_remote_datasource.dart';
import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  late final ProfileLocalDataSource _profileLocalDataSource;
  late final ProfileRemoteDataSource _profileRemoteDataSource;

  ProfileRepositoryImpl() {
    _profileLocalDataSource = ProfileLocalDataSource();
    _profileRemoteDataSource = ProfileRemoteDataSource();
  }

  @override
  Future<void> openProfileBox() async {
    await _profileLocalDataSource.initProfileBox();
  }

  @override
  Future<Profile?> createUserProfile({required User? authUser}) async {
    if (authUser == null || authUser.uid.isEmpty) return null;

    try {
      await _profileRemoteDataSource.createProfile(authUser: authUser);

      final profile = _profileRemoteDataSource
          .getProfileById(userID: authUser.uid)
          .then((profile) => profile);

      return profile;
    } catch (_) {
      log('🚀log⚡ Error when get info user');
      return null;
    }
  }

  @override
  Future<Profile?> getUserProfile({required String? userID}) async {
    if (userID == null) return null;

    try {
      final profile = _profileRemoteDataSource
          .getProfileById(userID: userID)
          .then((profile) => profile);
      return profile;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveToProfileBox({required Profile profile}) async {
    await _profileLocalDataSource.saveToProfileBox(profile);
  }

  getFile(){
    
  }
}
