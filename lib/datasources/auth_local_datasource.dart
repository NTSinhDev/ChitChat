import 'dart:developer';
import 'package:chat_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSource({required this.sharedPreferences});

  String? getUID() {
    final token = sharedPreferences.getString(StorageKey.kUID);
    return token;
  }

  Future<void> saveUIDToLocal(String uid) async {
    final isSaved = await sharedPreferences.setString(StorageKey.kUID, uid);
    //TODO: làm gì đó ở đây đi
    if (isSaved) {
      log('🚀log⚡ ngon!');
    } else {
      log('🚀log⚡ ỉa chảy!');
    }
  }

  Future<void> removeUID() async {
    final isRemoved = await sharedPreferences.remove(StorageKey.kUID);
    //TODO: làm gì đó ở đây đi
    if (isRemoved) {
    } else {}
  }
}
