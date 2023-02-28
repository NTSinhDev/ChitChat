part of 'setting_bloc.dart';

abstract class SettingState {
  final bool loading;

  SettingState(this.loading);
}

class SettingInitial extends SettingState {
  SettingInitial(super.loading);
}

class UpdatedAvatarState extends SettingState {
  final UserProfile userProfile;
  final bool? error;
  UpdatedAvatarState(
    super.loading, {
    required this.userProfile,
    this.error,
  });
}
