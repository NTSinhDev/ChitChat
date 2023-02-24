import 'package:chat_app/data/models/message.dart';

class ChatRoom {
  String? sId;
  List<String>? users;
  Message? lastMessage;
  int? state;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatRoom({
    this.sId,
    this.users,
    this.lastMessage,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ChatRoom.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    users = json['users'].cast<String>();
    lastMessage = json['lastMessage'] != null
        ? Message.fromJson(json['lastMessage'])
        : null;
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['users'] = users;
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    data['state'] = state;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
