import 'dart:convert';

import '../models/profile.dart';



Profile snapshotDataToProfile({required Object? data, required String id}) {
  final encodeData = json.encode(data);
  final convertToMap = json.decode(encodeData) as Map<String, dynamic>;
  return Profile.fromMap(convertToMap, id);
}
