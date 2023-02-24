// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.idSender,
    required this.content,
    required this.type,
    required this.time,
    required this.state,
  });

  String idSender;
  dynamic content;
  String type;
  String time;
  String state;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        idSender: json["idSender"],
        content: json["content"],
        type: json["type"],
        time: json["time"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "idSender": idSender,
        "content": content,
        "type": type,
        "time": time,
        "state": state,
      };
}
