import 'package:chat_app/features/personal/data/models/profile.dart';
import 'package:chat_app/features/personal/data/repository/profile_repository_impl.dart';
import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';

class GetUserProfile {
  late final ProfileRepository _profileRepository;

  GetUserProfile() {
    _profileRepository = ProfileRepositoryImpl();
  }

  Future<Profile?> getProfile({required String userID}) async {
    return await _profileRepository.getUserProfile(userID: userID);
  }
}
