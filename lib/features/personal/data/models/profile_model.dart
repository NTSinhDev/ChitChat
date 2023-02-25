import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  String fullName;
  @HiveField(3)
  String? messagingToken;

  ProfileModel({
    this.id,
    required this.email,
    required this.fullName,
    this.messagingToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'fullname': fullName,
      'userMessagingToken': messagingToken,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return ProfileModel(
      id: id,
      email: map['email'] as String,
      fullName: map['fullname'] as String,
      messagingToken: map['userMessagingToken'] != null
          ? map['userMessagingToken'] as String
          : null,
    );
  }
}
