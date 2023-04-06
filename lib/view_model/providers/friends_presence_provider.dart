import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/injector.dart';

class FriendPresenceProvider extends ChangeNotifier {
  final Profile currentUser;

  List<UserProfile> _onlineList = [];
  List<UserProfile> get onlineFriends => _onlineList;

  final _presenceRemoteDS = PresenceRemoteDatasourceImpl();
  FriendPresenceProvider({
    required this.currentUser,
  });

  getFriends(List<ConversationData> conversationsData) {
    List<UserProfile> newFriends = [];
    for (var i = 0; i < conversationsData.length; i++) {
      if (conversationsData[i].friend.profile!.id! != currentUser.id!) {
        newFriends.add(conversationsData[i].friend);
      }
    }
    _onlineList = newFriends;
    notifyListeners();
    // _removeUserNotOnl();
  }

  _removeUserNotOnl() {
    final newOnlineFriend = _onlineList;
    for (var i = 0; i < _onlineList.length; i++) {
      
    }
    _onlineList = newOnlineFriend;
    notifyListeners();
  }
}
