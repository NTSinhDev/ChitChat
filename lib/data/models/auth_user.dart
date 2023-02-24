
import 'package:chat_app/data/models/access_token.dart';
import 'package:chat_app/data/models/user_presence.dart';

class AuthUser {
  AccessToken? accessToken;
  User? user;
  UserPresence? userPresence;
  List<dynamic>? chatRooms;
  List<dynamic>? friendRequests;
  List<dynamic>? listFriend;

  AuthUser({
    this.accessToken,
    this.user,
    this.userPresence,
    this.chatRooms,
    this.friendRequests,
    this.listFriend,
  });

  AuthUser.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'] != null
        ? AccessToken.fromJson(json['accessToken'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userPresence = json['userPresence'] != null
        ? UserPresence.fromJson(json['userPresence'])
        : null;
    chatRooms = json['chatRooms'];
    friendRequests = json['friendRequests'];
    listFriend = json['listFriend'];
  }
}

class User {
  String? sId;
  String? email;
  String? name;
  String? password;
  bool? isDarkMode;
  String? urlImage;
  int? iV;

  User(
      {this.sId,
      this.email,
      this.name,
      this.password,
      this.isDarkMode,
      this.urlImage,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    isDarkMode = json['isDarkMode'];
    urlImage = json['urlImage'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['isDarkMode'] = isDarkMode;
    data['urlImage'] = urlImage;
    data['__v'] = iV;
    return data;
  }
}
