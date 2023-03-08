import 'dart:developer';

import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/enum/enums.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/data/datasources/local_datasources/injector.dart';

//* local
abstract class UserInformationLocalRepository {
  Future<void> saveImageFile({required UserProfile? userProfile});
  Future<void> saveProfile({required Profile? profile});
  Future<UserProfile?> getProfile({required String userID});
}

class _LocalRepositoryImpl implements UserInformationLocalRepository {
  late final StorageLocalDataSource _storageLocalDS;
  ProfileLocalDataSource? _profileLocalDS;
  bool isInitProfileLocalDS = false;
  _LocalRepositoryImpl() {
    _storageLocalDS = StorageLocalDataSourceImpl();
  }
  @override
  Future<void> saveImageFile({required UserProfile? userProfile}) async {
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
  Future<void> saveProfile({required Profile? profile}) async {
    if (profile == null) return;

    await _checkInitProfileLocalDS();
    try {
      await _profileLocalDS!.saveProfileToBox(profile);
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Future<UserProfile?> getProfile({required String userID}) async {
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

//* remote
abstract class UserInformationRemoteRepository {
  Future<List<UserProfile>> searchUserByName({required String searchName});
  Future<URLImage?> updateAvatar({
    required String path,
    required String userID,
  });
  Future updatePresence({required String id});
}

class _RemoteRepositoryImpl implements UserInformationRemoteRepository {
  late final ProfileRemoteDataSource _personalInforRemote;
  late final PresenceRemoteDatasource _presenceRemote;

  _RemoteRepositoryImpl()
      : _personalInforRemote = ProfileRemoteDataSourceImpl(),
        _presenceRemote = PresenceRemoteDatasourceImpl();

  @override
  Future updatePresence({required String id}) async {
    if (id.isEmpty) return;
    return _presenceRemote.updatePresence(userID: id);
  }


  @override
  Future<List<UserProfile>> searchUserByName({
    required String searchName,
  }) async {
    try {
      List<Profile> profiles = [];
      // get profiles
      switch (searchName) {
        case '':
          profiles = await _personalInforRemote.getAllProfile();
          break;
        default:
          profiles = await _personalInforRemote.getAllProfileByName(
            name: searchName,
          );
      }
      if (profiles.isEmpty) {
        return [];
      }
      // get Avatars
      final users = await _getUserProfilesFromProfiles(profiles: profiles);
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserProfile>> _getUserProfilesFromProfiles({
    required List<Profile> profiles,
  }) async {
    List<UserProfile> userProfiles = [];

    for (var i = 0; i < profiles.length; i++) {
      final url = await _personalInforRemote.getFile(
        filePath: StorageKey.pPROFILE,
        fileName: profiles[i].id ?? '',
      );
      final URLImage urlImage = URLImage(url: url, type: TypeImage.remote);
      userProfiles.add(UserProfile(urlImage: urlImage, profile: profiles[i]));
    }
    return userProfiles;
  }

  @override
  Future<URLImage?> updateAvatar({
    required String path,
    required String userID,
  }) async {
    final image = await _personalInforRemote.uploadFile(
      image: path,
      type: FileUploadType.path,
      filePath: StorageKey.pPROFILE,
      fileName: userID,
    );
    if (image == null) return null;
    return URLImage(url: image, type: TypeImage.remote);
  }
}

class UserInformationRepository {
  final _LocalRepositoryImpl _lc = _LocalRepositoryImpl();
  UserInformationLocalRepository get lc => _lc;
  final _RemoteRepositoryImpl _rm = _RemoteRepositoryImpl();
  UserInformationRemoteRepository get rm => _rm;
}
