import 'dart:developer';

import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/enum/enums.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/data/datasources/local_datasources/injector.dart';

part 'local_repository.dart';
part 'remote_repository.dart';

class UserInformationRepository {
  final UserInformationLocalRepository _lc = _LocalRepositoryImpl();
  UserInformationLocalRepository get lc => _lc;
  final UserInformationRemoteRepository _rm = _RemoteRepositoryImpl();
  UserInformationRemoteRepository get rm => _rm;
}
