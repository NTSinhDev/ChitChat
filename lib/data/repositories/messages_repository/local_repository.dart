part of 'messages_repository.dart';

abstract class MessagesLocalRepository {
  Future<List<Message>> getMessageList({
    required String conversationId,
  });
  Future<void> createMessage({required Message message});
}

class _LocalRepositoryImpl implements MessagesLocalRepository {
  final _mesageLocalDS = MessagesLocalDataSourceImpl();
  @override
  Future<void> createMessage({required Message message}) async {
    await _mesageLocalDS.createMessage(message: message);
  }

  @override
  Future<List<Message>> getMessageList({
    required String conversationId,
  }) async {
    await _mesageLocalDS.init(conversationId: conversationId);
    return _mesageLocalDS.getMessages().toList();
  }
}
