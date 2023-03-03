import 'package:chat_app/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationMessagesRemoteDataSource {}

class ConversationMessagesRemoteDataSourceImpl
    implements ConversationMessagesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _conversationMessageDoc;

  ConversationMessagesRemoteDataSourceImpl() {
    _conversationMessageDoc =
        _firestore.collection(ConversationMessagesField.collectionName);
  }
}
