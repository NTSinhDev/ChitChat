import 'package:chat_app/core/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationsRemoteDataSource {}

class ConversationsRemoteDataSourceImpl
    implements ConversationsRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _conversationDoc;

  ConversationsRemoteDataSourceImpl() {
    _conversationDoc = _firestore.collection(ConversationsField.collectionName);
  }
}
