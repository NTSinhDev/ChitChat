part of 'messages_repository.dart';

abstract class MessagesRemoteRepository {
  Future<bool> createMessage({
    required String senderID,
    required String conversationID,
    required String message,
  });
  Stream<Iterable<Message>> getMessageList({required String conversationId});
}

class _RemoteRepositoryImpl implements MessagesRemoteRepository {
  final _messageRemoteDS = MessagesRemoteDataSourceImpl();

  @override
  Future<bool> createMessage({
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
      messageType: MessageType.text.toString(),
      messageStatus: MessageStatus.sent.toString(),
    );

    return await _messageRemoteDS.createNewMessage(message: messageModel);
  }

  @override
  Stream<Iterable<Message>> getMessageList({required String conversationId}) {
    return _messageRemoteDS.getMessageList(conversationId: conversationId);
  }
}
