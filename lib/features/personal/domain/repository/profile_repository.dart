import 'package:firebase_auth/firebase_auth.dart';

import '../entity/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> createUserProfile({required User? authUser});

  Future<Profile?> getUserProfile({required String? userID});

  Future<void> saveToProfileBox({required Profile profile});

  Future<Profile?> getProfileAtLocalStorage({required String userID});
}
