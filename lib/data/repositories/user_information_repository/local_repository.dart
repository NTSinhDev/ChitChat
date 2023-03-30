part of 'user_information_repository.dart';

abstract class LocalUserInformationRepository {
  Future<void> saveImageFile({required UserProfile? userProfile});
  Future<void> saveProfile({required Profile? profile});
  Future<UserProfile?> getProfile({required String userID});
}

class _LocalRepositoryImpl implements LocalUserInformationRepository {
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
    
    catch (e) {
      log('🚀saveProfile⚡ ERROR: \n ${e.toString()}');
    }
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
