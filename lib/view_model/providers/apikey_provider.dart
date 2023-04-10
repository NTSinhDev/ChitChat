import 'dart:developer';

import 'package:chat_app/data/datasources/remote_datasources/key_remote_datesource.dart';
import 'package:flutter/cupertino.dart';

class APIKeyProvider extends ChangeNotifier {
  String messagingServerKey = '';
  String chatGPTKey = '';

  Future<void> getAPIKey() async {
    final List<String> apikeys = await KeyRemoteDataSourceImpl().getAPIKey();
    if (apikeys.isNotEmpty) {
      log('💯 đã lấy được api key');
      messagingServerKey = "key=${apikeys.first}";
      chatGPTKey = apikeys.last;
      notifyListeners();
    }
  }
}
