import 'package:hive/hive.dart';

import '../models/profile.dart';

class ProfileLocalDataSource {
  late Box<Profile> _profileBox;

  ProfileLocalDataSource() {
    initProfileBox();
  }

  Future<void> initProfileBox() async {
    if (!Hive.isAdapterRegistered(ProfileAdapter().typeId)) {
      Hive.registerAdapter(ProfileAdapter());
    }
    _profileBox = await Hive.openBox<Profile>('Profile');
  }

  Future<void> saveToProfileBox(Profile profile) async {
    await initProfileBox();
    final isOpen = !_profileBox.isOpen;
    final contain = _profileBox.containsKey(profile.id);
    if (isOpen || contain) return;

    await _profileBox.put(profile.id, profile);
  }
}
