import 'dart:developer';

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/models/profile.dart';
import 'package:hive/hive.dart';

abstract class ProfileLocalDataSource {
  Future<Box<Profile>?> openBox();
  Future<void> saveProfileToBox(Profile profile);
  Profile? getProfile(String key);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  late Box<Profile> _profileBox;

  @override
  Future<Box<Profile>?> openBox() async {
    Box<Profile>? isOpen;

    if (!Hive.isAdapterRegistered(ProfileAdapter().typeId)) {
      Hive.registerAdapter(ProfileAdapter());
    }

    _profileBox = await Hive.openBox<Profile>(StorageKey.bPROFILE);
    isOpen = _profileBox;
    return isOpen;
  }

  @override
  Future<void> saveProfileToBox(Profile profile) async {
    final isOpen = !_profileBox.isOpen;
    final contain = _profileBox.containsKey(profile.id);
    if (isOpen || contain) return;

    await _profileBox.put(profile.id, profile);
  }

  @override
  Profile? getProfile(String key) {
    if (!_profileBox.isOpen) {
      log('🚀log⚡ chua mo');
      return null;
    }
    return _profileBox.get(key);
  }
}
