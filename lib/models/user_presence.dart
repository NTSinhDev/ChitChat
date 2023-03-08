import 'package:chat_app/utils/constants.dart';

class UserPresence {
  String? id;
  final DateTime timestamp;
  bool status = false;
  UserPresence(
    this.id,
    this.timestamp,
    this.status,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      PresenceTree.timestampField: timestamp.millisecondsSinceEpoch,
      PresenceTree.statusField: status,
    };
  }

  factory UserPresence.fromMap(Map<String, dynamic> map, String id) {
    return UserPresence(
      id,
      DateTime.parse(map[PresenceTree.timestampField]),
      map[PresenceTree.statusField] as bool,
    );
  }

  @override
  String toString() =>
      'UserPresence(stamp_time: $timestamp, presence: $status)';
}
