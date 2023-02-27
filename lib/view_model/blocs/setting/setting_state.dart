part of 'setting_bloc.dart';

abstract class SettingState {
  final bool loading;

  SettingState(this.loading);
}

class SettingInitial extends SettingState {
  final bool? error;
  SettingInitial(super.loading, {this.error});
}
