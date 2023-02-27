import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/repositories/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/models/user_profile.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  UserProfile userProfile;
  final ProfileRepository repository = ProfileRepositoryImpl();
  SettingBloc(
    this.userProfile,
  ) : super(SettingInitial(false)) {
    on<UpdateAvatarEvent>((event, emit) async {
      emit(SettingInitial(true));

      if (userProfile.profile!.id == null || userProfile.profile!.id!.isEmpty) {
        return emit(SettingInitial(false));
      }

      final urlImage = await repository.updateAvatar(
        path: event.path,
        userID: userProfile.profile!.id!,
      );

      if (urlImage == null) return emit(SettingInitial(false, error: true));

      userProfile = UserProfile(
        profile: userProfile.profile,
        urlImage: urlImage,
      );
      
      emit(SettingInitial(false));
    });
  }
}
