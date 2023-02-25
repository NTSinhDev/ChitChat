import 'dart:developer';

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/models/profile.dart';
import 'package:hive/hive.dart';

class ProfileLocalDataSource {
  late Box<Profile> _profileBox;

  Future<Box<Profile>?> openBox() async {
    Box<Profile>? isOpen;

    if (!Hive.isAdapterRegistered(ProfileAdapter().typeId)) {
      Hive.registerAdapter(ProfileAdapter());
    }

    _profileBox = await Hive.openBox<Profile>(StorageKey.kPROFILEBOX);
    isOpen = _profileBox;
    return isOpen;
  }

  Future<void> saveToProfileBox(Profile profile) async {
    await openBox();
    final isOpen = !_profileBox.isOpen;
    final contain = _profileBox.containsKey(profile.id);
    if (isOpen || contain) return;

    await _profileBox.put(profile.id, profile);
  }

  Profile? getProfile(String key) {
    if (!_profileBox.isOpen) {
      log('🚀log⚡ chua mo');
      return null;
    }
    return _profileBox.get(key);
  }
}
