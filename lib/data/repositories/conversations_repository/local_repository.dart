part of 'conversations_repository.dart';

abstract class LocalConversationsRepository {
  Future<void> createConversation({required Conversation conversation});
  Future<Iterable<Conversation>> getConversations();
  Conversation? getConversation({required String key});
  Future<void> openConversationsBox();
}

class _LocalRepositoryImpl implements LocalConversationsRepository {
  final _conversationsLocalDS = ConversationsLocalDataSourceImpl();
  @override
  Future<void> createConversation({required Conversation conversation}) async {
    await _conversationsLocalDS.createConversation(conversation: conversation);
  }

  @override
  Conversation? getConversation({required String key}) =>
      _conversationsLocalDS.getConversation(key: key);

  @override
  Future<Iterable<Conversation>> getConversations() async {
    return _conversationsLocalDS.getConversations();
  }

  @override
  Future<void> openConversationsBox() async {
    await _conversationsLocalDS.init();
  }
}
