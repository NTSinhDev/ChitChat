import 'package:chat_app/features/personal/data/repository/profile_repository_impl.dart';
import 'package:chat_app/features/personal/domain/repository/profile_repository.dart';

class OpenProfileBox {
  final ProfileRepository profileRepository = ProfileRepositoryImpl();

  Future<void> open() async {
    await profileRepository.openProfileBox();
  }
}
