import 'dart:developer';

import 'package:chat_app/core/utils/constants.dart';
import 'package:hive/hive.dart';

import '../models/profile_model.dart';

class ProfileLocalDataSource {
  late Box<ProfileModel> _profileBox;

  Future<Box<ProfileModel>?> openBox() async {
    Box<ProfileModel>? isOpen;

    if (!Hive.isAdapterRegistered(ProfileModelAdapter().typeId)) {
      Hive.registerAdapter(ProfileModelAdapter());
    }

    _profileBox = await Hive.openBox<ProfileModel>(StorageKey.kPROFILEBOX);
    isOpen = _profileBox;
    return isOpen;
  }

  Future<void> saveToProfileBox(ProfileModel profile) async {
    await openBox();
    final isOpen = !_profileBox.isOpen;
    final contain = _profileBox.containsKey(profile.id);
    if (isOpen || contain) return;

    await _profileBox.put(profile.id, profile);
  }

  ProfileModel? getProfileModel(String key) {
    if (!_profileBox.isOpen) {
      log('🚀log⚡ chua mo');
      return null;
    }
    return _profileBox.get(key);
  }
}
