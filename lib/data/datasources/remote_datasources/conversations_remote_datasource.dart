import 'dart:developer';

import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:chat_app/models/injector.dart';
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
    required String id,
    required Map<String, dynamic> data,
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
  Future<bool> updateConversation({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _conversationCollection.doc(id).update(data);
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
      log('🚀Lỗi khi tạo phòng hoặc lấy thông tin phòng chat! \nChi tiết: ${e.toString()}');
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
