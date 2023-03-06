import 'dart:developer';

import 'package:chat_app/res/enum/enums.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/data/datasources/local_datasources/injector.dart';
import 'package:chat_app/data/datasources/remote_datasources/profile_remote_datasource.dart';
import 'package:chat_app/models/profile.dart';
import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/models/user_profile.dart';

abstract class UserInformationRepository {
  Future<List<UserProfile>> rmSearchUserByName({required String searchName});
  Future<URLImage?> rmUpdateAvatar({
    required String path,
    required String userID,
  });
  Future<void> lcSaveImageFile({required UserProfile? userProfile});
  Future<void> lcSaveProfile({required Profile? profile});
  Future<UserProfile?> lcGetProfile({required String userID});
}

class UserInformationRepositoryImpl implements UserInformationRepository {
  late final ProfileRemoteDataSource _personalInforRemoteDS;
  late final StorageLocalDataSource _storageLocalDS;

  ProfileLocalDataSource? _profileLocalDS;
  bool isInitProfileLocalDS = false;

  UserInformationRepositoryImpl() {
    _personalInforRemoteDS = ProfileRemoteDataSourceImpl();
    _storageLocalDS = StorageLocalDataSourceImpl();
  }

  @override
  Future<List<UserProfile>> rmSearchUserByName({
    required String searchName,
  }) async {
    try {
      List<Profile> profiles = [];
      // get profiles
      switch (searchName) {
        case '':
          profiles = await _personalInforRemoteDS.getAllProfile();
          break;
        default:
          profiles = await _personalInforRemoteDS.getAllProfileByName(
            name: searchName,
          );
      }
      if (profiles.isEmpty) {
        return [];
      }
      // get Avatars
      final users = await getUserProfilesFromProfiles(profiles: profiles);
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserProfile>> getUserProfilesFromProfiles({
    required List<Profile> profiles,
  }) async {
    List<UserProfile> userProfiles = [];

    for (var i = 0; i < profiles.length; i++) {
      final url = await _personalInforRemoteDS.getFile(
        filePath: StorageKey.pPROFILE,
        fileName: profiles[i].id ?? '',
      );
      final URLImage urlImage = URLImage(url: url, type: TypeImage.remote);
      userProfiles.add(UserProfile(urlImage: urlImage, profile: profiles[i]));
    }
    return userProfiles;
  }

  @override
  Future<URLImage?> rmUpdateAvatar({
    required String path,
    required String userID,
  }) async {
    final image = await _personalInforRemoteDS.uploadFile(
      image: path,
      type: FileUploadType.path,
      filePath: StorageKey.pPROFILE,
      fileName: userID,
    );
    if (image == null) return null;
    return URLImage(url: image, type: TypeImage.remote);
  }

  @override
  Future<void> lcSaveImageFile({required UserProfile? userProfile}) async {
    if (userProfile == null ||
        userProfile.profile == null ||
        userProfile.profile?.id == null ||
        userProfile.urlImage.url == null) return;

    final fileName = userProfile.profile!.id!;
    final remotePath = userProfile.urlImage.url!;
    await _storageLocalDS.uploadFile(
      fileName: fileName,
      remotePath: remotePath,
    );
  }

  @override
  Future<void> lcSaveProfile({required Profile? profile}) async {
    if (profile == null) return;

    await _checkInitProfileLocalDS();
    try {
      await _profileLocalDS!.saveProfileToBox(profile);
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Future<UserProfile?> lcGetProfile({required String userID}) async {
    await _checkInitProfileLocalDS();

    try {
      final Profile? profile = _profileLocalDS!.getProfile(userID);
      final url = await _storageLocalDS.getFile(fileName: userID);
      final urlImage = URLImage(url: url, type: TypeImage.local);
      return UserProfile(urlImage: urlImage, profile: profile);
    } catch (e) {
      log('🚀log⚡ error get profile at local: $e');
      return null;
    }
  }

  Future _checkInitProfileLocalDS() async {
    int i = 0;
    do {
      if (i != 0) {
        await _initLocalDataSource();
      }
      i++;
    } while (!isInitProfileLocalDS);
  }

  Future _initLocalDataSource() async {
    try {
      _profileLocalDS = ProfileLocalDataSourceImpl();

      final box =
          await _profileLocalDS!.openBox().timeout(const Duration(seconds: 10));

      isInitProfileLocalDS = box == null ? false : true;
    } catch (e) {
      isInitProfileLocalDS = false;
    }
  }
}
