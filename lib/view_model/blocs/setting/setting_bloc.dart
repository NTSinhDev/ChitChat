import 'package:chat_app/repositories/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/models/user_profile.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  UserProfile userProfile;

  late final UserInformationRepository _userInforRepository;

  SettingBloc(this.userProfile) : super(SettingInitial(false)) {
    _userInforRepository = UserInformationRepositoryImpl();

    on<UpdateAvatarEvent>((event, emit) async {
      emit(UpdatedAvatarState(true, userProfile: userProfile));

      if (userProfile.profile!.id == null || userProfile.profile!.id!.isEmpty) {
        return emit(UpdatedAvatarState(
          false,
          userProfile: userProfile,
          error: true,
        ));
      }

      final urlImage = await _userInforRepository.rmUpdateAvatar(
        path: event.path,
        userID: userProfile.profile!.id!,
      );

      if (urlImage == null) {
        return emit(UpdatedAvatarState(
          false,
          error: true,
          userProfile: userProfile,
        ));
      }

      userProfile = UserProfile(
        profile: userProfile.profile,
        urlImage: urlImage,
      );

      await _userInforRepository.lcSaveImageFile(userProfile: userProfile);

      emit(UpdatedAvatarState(false, userProfile: userProfile));
    });
  }
}
