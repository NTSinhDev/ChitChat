import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/data/datasources/local_datasources/messages_local_datasource.dart';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:uuid/uuid.dart';

part 'local_repository.dart';
part 'remote_repository.dart';

class MessagesRepository {
  final LocalMessagesRepository _lc = _LocalRepositoryImpl();
  LocalMessagesRepository get local => _lc;
  final RemoteMessagesRepository _rm = _RemoteRepositoryImpl();
  RemoteMessagesRepository get remote => _rm;
}
