import 'package:chat_app/models/user_profile.dart';

import '../datasources/local_datasources/injector.dart';

abstract class StorageRepository {
  Future<void> saveFileToStorage({required UserProfile? userProfile});
}

class StorageRepositoryImpl implements StorageRepository {
  late final StorageLocalDataSource _storageLocalDataSource;

  StorageRepositoryImpl() {
    _storageLocalDataSource = StorageLocalDataSourceImpl();
  }

  @override
  Future<void> saveFileToStorage({required UserProfile? userProfile}) async {
    if (userProfile == null ||
        userProfile.profile == null ||
        userProfile.profile?.id == null ||
        userProfile.urlImage.url == null) return;

    final fileName = userProfile.profile!.id!;
    final remotePath = userProfile.urlImage.url!;
    await _storageLocalDataSource.uploadFile(
      fileName: fileName,
      remotePath: remotePath,
    );
  }
}
