import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ConversationsLocalDataSource {
  Future<void> createConversation({required Conversation conversation});
  Iterable<Conversation>? getConversations();
  Conversation? getConversation({required String key});
}

class MessagesLocalDataSourceImpl implements ConversationsLocalDataSource {
  late Box<Conversation> _conversationBox;

  Future<void> init({required String conversationId}) async {
    if (!Hive.isAdapterRegistered(MessageAdapter().typeId)) {
      Hive.registerAdapter(MessageAdapter());
    }
    _conversationBox = await Hive.openBox(ConversationsField.collectionName);
  }

  @override
  Future<void> createConversation({required Conversation conversation}) async {
    if (_conversationBox.isOpen) {
      if (!_conversationBox.containsKey(conversation.id)) {
        await _conversationBox.put(
          conversation.id,
          conversation,
        );
      }
    }
  }

  @override
  Iterable<Conversation>? getConversations() {
    if (_conversationBox.isOpen) {
      return _conversationBox.values;
    }
    return null;
  }

  @override
  Conversation? getConversation({required String key}) {
    if (!_conversationBox.isOpen) {
      return null;
    }
    return _conversationBox.get(key);
  }
}
