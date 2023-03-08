import 'package:chat_app/res/enum/enums.dart';
import 'package:chat_app/data/datasources/local_datasources/messages_local_datasource.dart';
import 'package:chat_app/data/datasources/remote_datasources/messages_remote_datasource.dart';
import 'package:chat_app/models/injector.dart';
import 'package:uuid/uuid.dart';

part 'local_repository.dart';
part 'remote_repository.dart';

class MessagesRepository {
  final MessagesLocalRepository _lc = _LocalRepositoryImpl();
  MessagesLocalRepository get lc => _lc;
  final MessagesRemoteRepository _rm = _RemoteRepositoryImpl();
  MessagesRemoteRepository get rm => _rm;
}
