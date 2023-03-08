import 'package:chat_app/data/datasources/remote_datasources/presence_remote_datasource.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PresenceProvider extends ChangeNotifier {
  late final PresenceRemoteDatasource _presenceRemote;

  PresenceProvider() {
    _presenceRemote = PresenceRemoteDatasourceImpl();
  }

  Stream<DatabaseEvent> getPresence({required String userID}) {
    return _presenceRemote.getPresence(userID: userID);
  }

  
}
