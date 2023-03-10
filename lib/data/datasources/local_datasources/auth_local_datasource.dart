import 'dart:developer';
import 'package:chat_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  String? getUID();
  Future<void> saveUIDToLocal(String uid);
  Future<void> removeUID();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  String? getUID() => sharedPreferences.getString(StorageKey.sUID);

  @override
  Future<void> saveUIDToLocal(String uid) async {
    final isSaved = await sharedPreferences.setString(StorageKey.sUID, uid);
    //TODO: làm gì đó ở đây đi
    if (isSaved) {
      log('🚀log⚡ ngon!');
    } else {
      log('🚀log⚡ ỉa chảy!');
    }
  }

  @override
  Future<void> removeUID() async {
    final isRemoved = await sharedPreferences.remove(StorageKey.sUID);
    //TODO: làm gì đó ở đây đi
    if (isRemoved) {
    } else {}
  }
}
