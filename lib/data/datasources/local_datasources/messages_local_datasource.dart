import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:hive/hive.dart';

abstract class MessagesLocalDataSource {
  Iterable<Message> getMessages();
  Future<void> createMessage({required Message message});
}

class MessagesLocalDataSourceImpl implements MessagesLocalDataSource {
  late Box<Message> _messageBox;
  Future<void> init({required String conversationId}) async {
    if (!Hive.isAdapterRegistered(MessageAdapter().typeId)) {
      Hive.registerAdapter(MessageAdapter());
    }
    _messageBox = await Hive.openBox('messages:$conversationId');
  }

  @override
  Future<void> createMessage({required Message message}) async {
    if (_messageBox.isOpen) {
      if (!_messageBox.containsKey(message.id)) {
        await _messageBox.put(
          message.id,
          message,
        );
      }
    }
  }

  @override
  Iterable<Message> getMessages() {
    if (_messageBox.isOpen) {
      return _messageBox.values;
    }
    return [];
  }
}
