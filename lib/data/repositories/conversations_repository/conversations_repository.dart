import 'dart:developer';

import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/data/datasources/local_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';

part 'local_repository.dart';
part 'remote_repository.dart';

class ConversationsRepository {
  final LocalConversationsRepository _lc = _LocalRepositoryImpl();
  LocalConversationsRepository get local => _lc;
  final RemoteConversationsRepository _rm = _RemoteRepositoryImpl();
  RemoteConversationsRepository get remote => _rm;
}
