import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repository/profile_repository_impl.dart';
import '../entity/profile.dart';

final ProfileRepository _profileRepository = ProfileRepositoryImpl();

class SaveToProfileBox {
  Future<void> save({required Profile profile}) async {
    await _profileRepository.saveToProfileBox(profile: profile);
  }
}

class GetUserProfile {
  Future<Profile?> getProfile({required String userID}) async {
    return _profileRepository.getUserProfile(userID: userID);
  }
}

class GetAuthProfileAtLocalStorage {
  Future<Profile?> get({required String userID}) async {
    return await _profileRepository.getProfileAtLocalStorage(userID: userID);
  }
}

class CreateNewUserProfile {
  Future<Profile?> create({required User authUser}) async {
    return await _profileRepository.createUserProfile(authUser: authUser);
  }
}
