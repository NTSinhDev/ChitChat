import 'dart:developer';

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessagesRemoteDataSource {
  Future<bool> createNewMessage({required Message message});
  Stream<Iterable<Message>> getMessageList({
    required String conversationId,
  });
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  late final CollectionReference _messageCollection;

  MessagesRemoteDataSourceImpl() {
    _messageCollection = FirebaseFirestore.instance.collection(
      ConversationMessagesField.collectionName,
    );
  }

  @override
  Stream<Iterable<Message>> getMessageList({
    required String conversationId,
  }) {
    return _messageCollection
        .doc(conversationId)
        .collection(ConversationMessagesField.colChildName)
        .orderBy(ConversationMessagesField.stampTime, descending: false)
        .snapshots()
        .map(
      (querySnapshot) {
        if (querySnapshot.docs.isEmpty || querySnapshot.size <= 0) {
          return [];
        }
        return querySnapshot.docs.map(
          (queryDocumentSnapshot) {
            return ParsedSnapshotData(parsedTo: ParsedTo.message).parsed(
              data: queryDocumentSnapshot.data(),
              id: queryDocumentSnapshot.id,
            );
          },
        );
      },
    );
  }

  @override
  Future<bool> createNewMessage({required Message message}) async {
    try {
      await _messageCollection
          .doc(message.conversationId)
          .collection(ConversationMessagesField.colChildName)
          .doc(message.id!)
          .set(message.toMap());
      return true;
    } catch (e) {
      log("Lỗi khi tạo mới tin nhắn để lưu trữ trên Firebase ${e.toString()}");
      return false;
    }
  }
}
