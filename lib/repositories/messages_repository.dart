import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/datasources/local_datasources/messages_local_datasource.dart';
import 'package:chat_app/datasources/remote_datasources/messages_remote_datasource.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:uuid/uuid.dart';

abstract class MessagesRepository {
  Future<bool> rmCreateMessage({
    required String senderID,
    required String conversationID,
    required String message,
  });
  Stream<Iterable<Message>> rmGetMessageList({required String conversationId});

  Future<List<Message>> lcGetMessageList({
    required String conversationId,
  });
  Future<void> lcCreateMessage({required Message message});
}

class MessagesRepositoryImpl implements MessagesRepository {
  final _messageRemoteDS = MessagesRemoteDataSourceImpl();
  final _mesageLocalDS = MessagesLocalDataSourceImpl();

  @override
  Future<void> lcCreateMessage({required Message message}) async {
    await _mesageLocalDS.createMessage(message: message);
  }

  @override
  Stream<Iterable<Message>> rmGetMessageList({required String conversationId}) {
    return _messageRemoteDS.getMessageList(conversationId: conversationId);
  }

  @override
  Future<List<Message>> lcGetMessageList({
    required String conversationId,
  }) async {
    await _mesageLocalDS.init(conversationId: conversationId);
    return _mesageLocalDS.getMessages().toList();
  }

  @override
  Future<bool> rmCreateMessage({
    required String senderID,
    required String conversationID,
    required String message,
  }) async {
    // create Message model
    final msgID = const Uuid().v4();
    final messageModel = Message(
      id: msgID,
      senderId: senderID,
      conversationId: conversationID,
      content: message,
      typeMessage: MessageType.text.toString(),
      messageStatus: MessageStatus.sent.toString(),
    );

    return await _messageRemoteDS.createNewMessage(message: messageModel);
  }
}
