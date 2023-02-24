import 'package:chat_app/features/personal/data/models/profile.dart';
import 'package:chat_app/features/personal/data/repository/profile_repository_impl.dart';
import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateNewUserProfile {
  late final ProfileRepository _profileRepository;
  CreateNewUserProfile() {
    _profileRepository = ProfileRepositoryImpl();
  }

  Future<Profile?> create({required User authUser}) async =>
      await _profileRepository.createUserProfile(authUser: authUser);
}
