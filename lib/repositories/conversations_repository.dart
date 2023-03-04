import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/datasources/remote_datasources/conversations_remote_datasource.dart';
import 'package:chat_app/models/models_injector.dart';

abstract class ConversationsRepository {
  Future<Conversation?> getConversationData({
    required List<String> userIDs,
  });
}

class ConversationsRepositoryImpl extends ConversationsRepository {
  final _conversationsRemoteDS = ConversationsRemoteDataSourceImpl();

  @override
  Future<Conversation?> getConversationData({
    required List<String> userIDs,
  }) async {
    // create id fields
    String createId = userIDs[0];
    String beCreatedId = userIDs[1];

    // Check is existed conversation
    final conversationID = await _conversationsRemoteDS.isExistedConversation(
      createID: createId,
      beCreatedID: beCreatedId,
    );

    Conversation? conversation = Conversation(
      id: createId == beCreatedId ? createId : createId + beCreatedId,
      typeMessage: MessageType.text.toString(),
      isActive: false,
      lastMessage: '',
      stampTime: DateTime.now(),
      stampTimeLastText: DateTime.now(),
      listUser: userIDs,
    );

    // Get convarsation data and create if necessary
    if (conversationID.isEmpty) {
      conversation = await _conversationsRemoteDS.createNewConversation(
        conversation: conversation,
      );
    } else {
      conversation = await _conversationsRemoteDS.getConversation(
        conversationId: conversationID,
      );
    }

    return conversation;
  }
}
