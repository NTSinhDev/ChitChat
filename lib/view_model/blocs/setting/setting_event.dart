// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'setting_bloc.dart';

abstract class SettingEvent {}

class UpdateAvatarEvent extends SettingEvent {
  final String path;
  UpdateAvatarEvent({
    required this.path,
  });
}
