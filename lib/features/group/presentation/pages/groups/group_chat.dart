import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/presentation/widgets/list_chat_room.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/presentation/widgets/search_bar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(theme: appState.darkMode),
          Container(
            margin: EdgeInsets.fromLTRB(
              14.w,
              14.h,
              14.w,
              0,
            ),
            child: Text(
              "Nhóm",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListChatRoom(
            listUsers: LIST_USERS,
            isGroup: false,
          ),
        ],
      ),
    );
  }
}
class User {
  String? id;
  String? username;
  String? email;
  String? password;
  bool? isDarkMode;
  String? avatar;
  bool? state;
  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.isDarkMode,
    this.avatar,
    this.state,
  });


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      isDarkMode: map['isDarkMode'] != null ? map['isDarkMode'] as bool : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      state: map['state'] != null ? map['state'] as bool : null,
    );
  }
  
}


// ignore: non_constant_identifier_names
List<dynamic> LIST_USERS = [
  [
    User(username: "Nguyễn Trường Sinh", avatar: 'user1.jpg', state: true,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Nguyễn Dộ", avatar: 'user2.jpg', state: true,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user3.jpg', state: false,),
    'Bạn: Hello, Peter!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    "Xì nêeeeeeeeeee!",
    '12:00',
  ],
  [
    User(username: "Ma Vương", avatar: 'user3.jpg', state: false,),
    "Ma Vương tới chơi :D!",
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
  [
    User(username: "Đại Ác Ma", avatar: 'user4.jpeg', state: false,),
    'Ban: Hello, world!',
    '12:00',
  ],
];
