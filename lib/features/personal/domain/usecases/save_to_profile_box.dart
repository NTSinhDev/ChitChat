import '../../data/models/profile.dart';
import '../../data/repository/profile_repository_impl.dart';
import '../repository/profile_repository.dart';

class SaveToProfileBox {
  late final ProfileRepository _profileRepository;

  SaveToProfileBox() {
    _profileRepository = ProfileRepositoryImpl();
  }

  Future<void> save({required Profile profile}) async {
    await _profileRepository.saveToProfileBox(profile: profile);
  }
}
