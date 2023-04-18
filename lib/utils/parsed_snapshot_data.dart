import 'dart:convert';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';

class ParsedSnapshotData {
  final ParsedTo parsedTo;
  ParsedSnapshotData({required this.parsedTo});

  dynamic parsed({required Object? data, required String id}) {
    final encodeData = json.encode(data);
    final parseToMap = json.decode(encodeData) as Map<String, dynamic>;
    switch (parsedTo) {
      case ParsedTo.profile:
        return Profile.fromMap(parseToMap, id);
      case ParsedTo.message:
        return Message.fromMap(parseToMap, id);
      default:
        return Conversation.fromMap(parseToMap, id);
    }
  }
}