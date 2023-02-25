import 'dart:convert';

import '../models/profile_model.dart';

ProfileModel snapshotDataToProfile({required Object? data, required String id}) {
  final encodeData = json.encode(data);
  final convertToMap = json.decode(encodeData) as Map<String, dynamic>;
  return ProfileModel.fromMap(convertToMap, id);
}
