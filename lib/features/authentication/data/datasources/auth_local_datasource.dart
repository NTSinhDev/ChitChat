import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final _key = 'UID';

  AuthLocalDataSource({required this.sharedPreferences});

  String? getUID() {
    final token = sharedPreferences.getString(_key);
    return token;
  }

  Future<void> saveUIDToLocal(String uid) async {
    final isSaved = await sharedPreferences.setString(_key, uid);
    //TODO: làm gì đó ở đây đi
    if (isSaved) {
      log('🚀log⚡ ngon!');
    } else {
      log('🚀log⚡ ỉa chảy!');
    }
  }

  Future<void> removeUID() async {
    final isRemoved = await sharedPreferences.remove(_key);
    //TODO: làm gì đó ở đây đi
    if (isRemoved) {
    } else {}
  }
}
