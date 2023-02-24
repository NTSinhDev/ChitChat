import 'package:chat_app/features/personal/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileRepository {
  Future<void> openProfileBox();

  Future<Profile?> createUserProfile({required User? authUser});

  Future<Profile?> getUserProfile({required String? userID});

  Future<void> saveToProfileBox({required Profile profile});
}
