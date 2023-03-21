part of 'conversations_repository.dart';

abstract class LocalConversationsRepository {
  Future<void> createConversation({required Conversation conversation});
  Iterable<Conversation>? getConversations();
  Conversation? getConversation({required String key});
}

class _LocalRepositoryImpl implements LocalConversationsRepository {
  final _mesageLocalDS = MessagesLocalDataSourceImpl();
  @override
  Future<void> createConversation({required Conversation conversation}) async {
    await _mesageLocalDS.createConversation(conversation: conversation);
  }

  @override
  Conversation? getConversation({required String key}) {
    return _mesageLocalDS.getConversation(key: key);
  }

  @override
  Iterable<Conversation>? getConversations() {
    return _mesageLocalDS.getConversations();
  }
}
