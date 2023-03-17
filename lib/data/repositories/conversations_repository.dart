import 'package:chat_app/utils/enum/enums.dart';
import 'package:chat_app/data/datasources/remote_datasources/conversations_remote_datasource.dart';
import 'package:chat_app/models/injector.dart';

abstract class ConversationsRepository {
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
}

class ConversationsRepositoryImpl extends ConversationsRepository {
  final _conversationsRemoteDS = ConversationsRemoteDataSourceImpl();

  

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
    if (conversationID.isEmpty) {
      return null;
    }
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
