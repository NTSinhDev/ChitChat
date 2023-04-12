part of 'user_information_repository.dart';

abstract class RemoteUserInformationRepository {
  Future<List<UserProfile>> searchUserByName({required String searchName});
  Future<URLImage?> updateAvatar({
    required String path,
    required String userID,
  });
  Future<String?> updatePresence({required String id});
  Future<UserProfile?> getInformationById({required String id});
  Future<bool> updateDeviceToken({
    required String deviceToken,
    required String currentToken,
    required String? userID,
  });
}

class _RemoteRepositoryImpl implements RemoteUserInformationRepository {
  late final ProfileRemoteDataSource _personalInforRemote;
  late final PresenceRemoteDatasource _presenceRemote;
  late final StorageRemoteDatasource _storageRemote;

  _RemoteRepositoryImpl()
      : _personalInforRemote = ProfileRemoteDataSourceImpl(),
        _storageRemote = StorageRemoteDatasourceImpl(),
        _presenceRemote = PresenceRemoteDatasourceImpl();

  @override
  Future<bool> updateDeviceToken({
    required String deviceToken,
    required String currentToken,
    required String? userID,
  }) async {
    if (userID == null || userID.isEmpty) return false;
    if (currentToken == deviceToken) return false;
    final newData = {
      ProfileField.userMessagingTokenField: deviceToken,
    };
    return await _personalInforRemote.updateProfile(
      data: newData,
      userID: userID,
    );
  }

  @override
  Future<String?> updatePresence({required String id}) async {
    if (id.isEmpty) return 'không có dữ liệu người dùng';
    return _presenceRemote.updatePresence(userID: id);
  }

  @override
  Future<List<UserProfile>> searchUserByName({
    required String searchName,
  }) async {
    try {
      final profiles = await _personalInforRemote.getAllProfileByName(
        name: searchName,
      );
      if (profiles.isEmpty) return [];

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
      final url = await _storageRemote.getFile(
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
    final image = await _storageRemote.uploadFile(
      path: path,
      type: FileUploadType.path,
      folderName: StorageKey.pPROFILE,
      fileName: userID,
    );
    if (image == null) return null;
    return URLImage(url: image, type: TypeImage.remote);
  }

  @override
  Future<UserProfile?> getInformationById({required String id}) async {
    final profile = await _personalInforRemote.getProfileById(userID: id);
    if (profile == null) return null;
    final userProfile = await _getUserProfilesFromProfiles(profiles: [profile]);
    return userProfile.first;
  }
}
