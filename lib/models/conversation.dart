import 'package:chat_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'conversation.g.dart';

@HiveType(typeId: 1)
class Conversation {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final DateTime stampTime;
  @HiveField(2)
  final DateTime stampTimeLastText;
  @HiveField(3)
  final String lastMessage;
  @HiveField(4)
  String? nameChat = "";
  @HiveField(5)
  bool isActive;
  @HiveField(6)
  final String typeMessage;
  @HiveField(7)
  List<String> listUser = [];
  @HiveField(8)
  List<String> readByUsers = [];

  Conversation({
    this.id,
    required this.typeMessage,
    required this.isActive,
    required this.lastMessage,
    this.nameChat,
    required this.stampTime,
    required this.stampTimeLastText,
    required this.listUser,
    required this.readByUsers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ConversationsField.chatID: id,
      ConversationsField.stampTime: stampTime.millisecondsSinceEpoch,
      ConversationsField.stampTimeLastText:
          stampTimeLastText.millisecondsSinceEpoch,
      ConversationsField.lastText: lastMessage,
      ConversationsField.nameChat: nameChat,
      ConversationsField.isActive: isActive,
      ConversationsField.typeMessage: typeMessage,
      ConversationsField.listUser: listUser,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map, String id) {
    return Conversation(
      id: id,
      stampTime: DateTime.fromMillisecondsSinceEpoch(
        map[ConversationsField.stampTime] as int,
      ),
      stampTimeLastText: DateTime.fromMillisecondsSinceEpoch(
        map[ConversationsField.stampTimeLastText] as int,
      ),
      lastMessage: map[ConversationsField.lastText] as String,
      nameChat: map[ConversationsField.nameChat] != null
          ? map['nameChat'] as String
          : null,
      isActive: map[ConversationsField.isActive] as bool,
      typeMessage: map[ConversationsField.typeMessage] as String,
      listUser: List<String>.from(map[ConversationsField.listUser] as List),
      readByUsers: map[ConversationsField.readByUsers] == null
          ? []
          : List<String>.from(map[ConversationsField.readByUsers] as List),
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, stampTime: $stampTime, stampTimeLastText: $stampTimeLastText, lastText: $lastMessage, nameChat: $nameChat, isActive: $isActive, typeMessage: $typeMessage, listUser: $listUser)';
  }

   @override
  bool operator ==(covariant Conversation other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.stampTime == stampTime &&
      other.stampTimeLastText == stampTimeLastText &&
      other.lastMessage == lastMessage &&
      other.nameChat == nameChat &&
      other.isActive == isActive &&
      other.typeMessage == typeMessage &&
      listEquals(other.listUser, listUser) &&
      listEquals(other.readByUsers, readByUsers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      stampTime.hashCode ^
      stampTimeLastText.hashCode ^
      lastMessage.hashCode ^
      nameChat.hashCode ^
      isActive.hashCode ^
      typeMessage.hashCode ^
      listUser.hashCode ^
      readByUsers.hashCode;
  }
}
