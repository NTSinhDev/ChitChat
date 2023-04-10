import 'dart:developer';

import 'package:chat_app/data/datasources/remote_datasources/presence_remote_datasource.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/injector.dart';
import 'package:rxdart/subjects.dart';

class FriendsProvider extends ChangeNotifier {
  final Profile currentUser;

  final _behaviorFriends = BehaviorSubject<List<UserProfile>>();
  Stream<List<UserProfile>> get friendsStream => _behaviorFriends.stream;
  FriendsProvider({required this.currentUser});

  getFriends(List<ConversationData> conversationsData) {
    List<UserProfile> friends = [];
    for (var i = 0; i < conversationsData.length; i++) {
      if (conversationsData[i].friend.profile!.id! != currentUser.id!) {
        friends.add(conversationsData[i].friend);
      }
    }
    _behaviorFriends.sink.add(friends);
  }

  @override
  Future<void> dispose() async {
    await _behaviorFriends.drain();
    await _behaviorFriends.close();
    super.dispose();
  }
}
