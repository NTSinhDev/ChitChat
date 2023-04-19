import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationsRemoteDataSource {
  Future<Conversation?> createNewConversation({
    required Conversation conversation,
  });
  Future<String> isExistedConversation({
    required String createID,
    required String beCreatedID,
  });
  Future<Conversation?> getConversation({required String conversationId});
  Future updateConversation({
    required String conversationID,
    required Map<String, dynamic> data,
  });
  Stream<Iterable<Conversation>> listenConversationsData({
    required String userId,
  });
}

class ConversationsRemoteDataSourceImpl
    implements ConversationsRemoteDataSource {
  late CollectionReference _conversationCollection;

  ConversationsRemoteDataSourceImpl() {
    _conversationCollection = FirebaseFirestore.instance.collection(
      ConversationsField.collectionName,
    );
  }

  @override
  Stream<Iterable<Conversation>> listenConversationsData({
    required String userId,
  }) =>
      _conversationCollection
          .where(ConversationsField.listUser, arrayContains: userId)
          .orderBy(
            ConversationsField.stampTimeLastText,
            descending: true,
          )
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.size == 0 || querySnapshot.docs.isEmpty) return [];

        return querySnapshot.docs.map(
          (queryDocumentSnapshot) {
            return ParsedSnapshotData(parsedTo: ParsedTo.conversation).parsed(
              data: queryDocumentSnapshot.data(),
              id: queryDocumentSnapshot.id,
            );
          },
        );
      });

  @override
  Future<bool> updateConversation({
    required String conversationID,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _conversationCollection.doc(conversationID).update(data);
      return true;
    } catch (e) {
      log("Lỗi khi cập nhật thông tin conversation ${e.toString()}");
      return false;
    }
  }

  @override
  Future<Conversation?> getConversation({
    required String conversationId,
  }) async {
    return await _conversationCollection.doc(conversationId).get().then(
      (docSnapshot) async {
        if (docSnapshot.exists) {
          return ParsedSnapshotData(parsedTo: ParsedTo.conversation).parsed(
            data: docSnapshot.data(),
            id: docSnapshot.id,
          ) as Conversation;
        }
        return null;
      },
    );
  }

  @override
  Future<Conversation?> createNewConversation({
    required Conversation conversation,
  }) async {
    try {
      return await _conversationCollection
          .doc(conversation.id)
          .set(conversation.toMap())
          .then((value) => getConversation(conversationId: conversation.id!));
    } catch (e) {
      log('🚀createNewConversation \nChi tiết: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<String> isExistedConversation({
    required String createID,
    required String beCreatedID,
  }) async {
    if (createID == beCreatedID) return await _isExistedDocument(createID);

    String conversationID = await _isExistedDocument(createID + beCreatedID);
    if (conversationID.isNotEmpty) return conversationID;

    return await _isExistedDocument(beCreatedID + createID);
  }

  Future<String> _isExistedDocument(String conversationID) async {
    return await _conversationCollection
            .doc(conversationID)
            .get()
            .then((docSnapshot) => docSnapshot.exists ? true : false)
        ? conversationID
        : '';
  }
}
