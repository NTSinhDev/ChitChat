part of 'conversations_repository.dart';

abstract class RemoteConversationsRepository {
  Future<Conversation?> getConversationData({
    required List<String> userIDs,
  });
  Future<Conversation?> createNewConversation({
    required List<String> userIDs,
    String? lastMsg,
  });
  Future<bool> updateConversation({
    required String id,
    required Map<String, dynamic> data,
  });
  Stream<Iterable<Conversation>?> conversationsDataStream({
    required String userId,
  });
}

class _RemoteRepositoryImpl implements RemoteConversationsRepository {
  final _conversationsRemoteDS = ConversationsRemoteDataSourceImpl();

  @override
  Stream<Iterable<Conversation>?> conversationsDataStream({
    required String userId,
  }) =>
      _conversationsRemoteDS.listenConversationsData(userId: userId);

  @override
  Future<bool> updateConversation({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await _conversationsRemoteDS.updateConversation(id: id, data: data);
  }

  @override
  Future<Conversation?> getConversationData({
    required List<String> userIDs,
  }) async {
    String createId = userIDs[0];
    String beCreatedId = userIDs[1];

    final conversationID = await _conversationsRemoteDS.isExistedConversation(
      createID: createId,
      beCreatedID: beCreatedId,
    );

    // Get convarsation data and create if necessary
    if (conversationID.isEmpty) return null;

    return await _conversationsRemoteDS.getConversation(
      conversationId: conversationID,
    );
  }

  @override
  Future<Conversation?> createNewConversation({
    required List<String> userIDs,
    String? lastMsg,
  }) async {
    final conversation = Conversation(
      id: userIDs[0] == userIDs[1] ? userIDs[0] + userIDs[1] : userIDs[1],
      typeMessage: MessageType.text.toString(),
      isActive: true,
      lastMessage: lastMsg ?? '',
      stampTime: DateTime.now(),
      stampTimeLastText: DateTime.now(),
      listUser: userIDs,
    );
    return await _conversationsRemoteDS.createNewConversation(
      conversation: conversation,
    );
  }
}
