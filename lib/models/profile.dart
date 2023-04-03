import 'package:chat_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 0)
class Profile {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  String fullName;
  @HiveField(3)
  String? messagingToken;
  bool isAdmin;

  Profile({
    this.id,
    required this.email,
    required this.fullName,
    this.messagingToken,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'fullname': fullName,
      'userMessagingToken': messagingToken,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map, String id) {
    return Profile(
      id: id,
      email: map[ProfileField.email] as String,
      fullName: map[ProfileField.fullName] as String,
      messagingToken: map[ProfileField.userMessagingToken] != null
          ? map[ProfileField.userMessagingToken] as String
          : null,
      isAdmin: map[ProfileField.isAdmin] == null ? false : true,
    );
  }
}
