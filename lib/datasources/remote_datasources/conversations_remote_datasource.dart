import 'dart:developer';

import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation.dart';

abstract class ConversationsRemoteDataSource {
  Future<Conversation?> createNewConversation({
    required Conversation conversation,
  });

  Future<String> isExistedConversation({
    required String createID,
    required String beCreatedID,
  });

  Future<Conversation?> getConversation({required String conversationId});
}

class ConversationsRemoteDataSourceImpl
    implements ConversationsRemoteDataSource {
  late CollectionReference _conversationDoc;

  ConversationsRemoteDataSourceImpl() {
    _conversationDoc = FirebaseFirestore.instance.collection(
      ConversationsField.collectionName,
    );
  }

  @override
  Future<Conversation?> getConversation({
    required String conversationId,
  }) async {
    return await _conversationDoc.doc(conversationId).get().then(
      (docSnapshot) async {
        if (docSnapshot.exists) {
          return ParsedSnapshotData(parsedTo: ParsedTo.conversation).to(
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
      return await _conversationDoc
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
    return await _conversationDoc
            .doc(conversationID)
            .get()
            .then((docSnapshot) => docSnapshot.exists ? true : false)
        ? conversationID
        : '';
  }
}
