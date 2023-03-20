import 'dart:convert';
import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';

class ParsedSnapshotData {
  final ParsedTo parsedTo;
  ParsedSnapshotData({required this.parsedTo});

  dynamic parsed({required Object? data, required String id}) {
    final encodeData = json.encode(data);
    final convertToMap = json.decode(encodeData) as Map<String, dynamic>;
    switch (parsedTo) {
      case ParsedTo.profile:
        return Profile.fromMap(convertToMap, id);
      case ParsedTo.message:
        return Message.fromMap(convertToMap, id);
      default:
        return Conversation.fromMap(convertToMap, id);
    }
  }
}

class SplitHelper {
  static String getFileName({required String path}) {
    final splitArray = path.split('/');
    return splitArray.last;
  }

  static String getFileExtension({required String fileName}) =>
      fileName.split('.').last;
}
