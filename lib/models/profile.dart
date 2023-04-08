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

  Profile({
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

  factory Profile.fromMap(Map<String, dynamic> map, String id) {
    return Profile(
      id: id,
      email: map[ProfileField.emailField] as String,
      fullName: map[ProfileField.fullNameField] as String,
      messagingToken: map[ProfileField.userMessagingTokenField] != null
          ? map[ProfileField.userMessagingTokenField] as String
          : null,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, email: $email, fullName: $fullName, messagingToken: $messagingToken)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.fullName == fullName &&
        other.messagingToken == messagingToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        fullName.hashCode ^
        messagingToken.hashCode;
  }
}
