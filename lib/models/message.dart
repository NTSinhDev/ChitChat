import 'package:chat_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 2)
class Message {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String conversationId;
  @HiveField(3)
  final String? content;
  @HiveField(4)
  final List<String> listNameImage;
  @HiveField(5)
  final String? nameRecord;
  @HiveField(6)
  final DateTime stampTime;
  @HiveField(7)
  final String messageType;
  @HiveField(8)
  String messageStatus;
  void setMessageStatus(String newStatus) {
    messageStatus = newStatus;
  }

  Message({
    required this.id,
    required this.senderId,
    required this.conversationId,
    required this.content,
    this.listNameImage = const [],
    this.nameRecord = '',
    DateTime? stampTime,
    required this.messageType,
    required this.messageStatus,
  }) : stampTime = stampTime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ConversationMessagesField.id: id,
      ConversationMessagesField.senderId: senderId,
      ConversationMessagesField.conversationId: conversationId,
      ConversationMessagesField.content: content,
      ConversationMessagesField.listNameImage: listNameImage,
      ConversationMessagesField.nameRecord: nameRecord,
      ConversationMessagesField.stampTime: stampTime.millisecondsSinceEpoch,
      ConversationMessagesField.typeMessage: messageType,
      ConversationMessagesField.messageStatus: messageStatus,
    };
  }

  factory Message.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return Message(
      id: id,
      senderId: map[ConversationMessagesField.senderId] as String,
      conversationId: map[ConversationMessagesField.conversationId] as String,
      content: map[ConversationMessagesField.content] != null
          ? map[ConversationMessagesField.content] as String
          : null,
      listNameImage: map[ConversationMessagesField.listNameImage] != null
          ? List<String>.from(
              (map[ConversationMessagesField.listNameImage] as List),
            )
          : [],
      nameRecord: map[ConversationMessagesField.nameRecord] != null
          ? map[ConversationMessagesField.nameRecord] as String
          : null,
      stampTime: DateTime.fromMillisecondsSinceEpoch(
        map[ConversationMessagesField.stampTime] as int,
      ),
      messageType: map[ConversationMessagesField.typeMessage] as String,
      messageStatus: map[ConversationMessagesField.messageStatus] as String,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, chatId: $conversationId, content: $content, listNameImage: $listNameImage, nameRecord: $nameRecord, stampTime: $stampTime, typeMessage: $messageType, messageStatus: $messageStatus)';
  }
}
