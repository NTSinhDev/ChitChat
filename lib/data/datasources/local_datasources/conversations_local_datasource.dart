import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ConversationsLocalDataSource {
  Future<void> createConversation({required Conversation conversation});
  Iterable<Conversation> getConversations();
  Conversation? getConversation({required String key});
}

class ConversationsLocalDataSourceImpl implements ConversationsLocalDataSource {
  late Box<Conversation> _conversationBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(ConversationAdapter().typeId)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    _conversationBox = await Hive.openBox(ConversationsField.collectionName);
  }

  @override
  Future<void> createConversation({required Conversation conversation}) async {
    if (!_conversationBox.isOpen) return;
    if (!_conversationBox.containsKey(conversation.id)) {
      await _conversationBox.put(
        conversation.id,
        conversation,
      );
    }
  }

  @override
  Iterable<Conversation> getConversations() {
    if (!_conversationBox.isOpen) return [];
    return _conversationBox.values;
  }

  @override
  Conversation? getConversation({required String key}) {
    if (!_conversationBox.isOpen) return null;
    return _conversationBox.get(key);
  }
}
