part of 'messages_repository.dart';

abstract class MessagesRemoteRepository {
  Future<bool> sendMessage({
    required String senderID,
    required String conversationID,
    String? messageContent,
    MessageType? messageType,
    List<String> images = const [],
  });
  Stream<Iterable<Message>> getMessageList({required String conversationId});
  Stream<String?> getFile({
    required String conversationID,
    required String senderID,
    required String fileName,
  });
}

class _RemoteRepositoryImpl implements MessagesRemoteRepository {
  final _messageRemoteDS = MessagesRemoteDataSourceImpl();
  final _storageRemoteDS = StorageRemoteDatasourceImpl();

  @override
  Future<bool> sendMessage({
    required String senderID,
    required String conversationID,
    String? messageContent,
    MessageType? messageType,
    List<String> images = const [],
  }) async {
    if (messageType != MessageType.text) {
      final link = "${StorageKey.pCONVERSATION}/$conversationID/$senderID";
      images = await _uploadFiles(images: images, link: link);
    }

    // create Message model
    final msgID = const Uuid().v4();
    final messageModel = Message(
      id: msgID,
      senderId: senderID,
      conversationId: conversationID,
      listNameImage: images,
      content: messageContent,
      messageType: messageType?.toString() ?? MessageType.text.toString(),
      messageStatus: MessageStatus.sent.toString(),
    );

    return await _messageRemoteDS.createNewMessage(message: messageModel);
  }

  Future<List<String>> _uploadFiles({
    required List<String> images,
    required String link,
  }) async {
    List<String> fileNames = [];
    for (var i = 0; i < images.length; i++) {
      final fileName = SplitHelper.getFileName(path: images[i]);
      await _storageRemoteDS.uploadFile(
        path: images[i],
        type: FileUploadType.path,
        folderName: link,
        fileName: fileName,
      );
      fileNames.add(fileName);
    }
    return fileNames;
  }

  @override
  Stream<Iterable<Message>> getMessageList({required String conversationId}) {
    return _messageRemoteDS.getMessageList(conversationId: conversationId);
  }

  @override
  Stream<String?> getFile({
    required String conversationID,
    required String senderID,
    required String fileName,
  }) {
    return _storageRemoteDS
        .getFile(
          filePath: "${StorageKey.pCONVERSATION}/$conversationID/$senderID",
          fileName: fileName,
        )
        .asStream();
  }
}
