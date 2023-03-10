import 'package:chat_app/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class PresenceRemoteDatasource {
  Future<void> updatePresence({required String userID});
  Stream<DatabaseEvent> getPresence({required String userID});
}

class PresenceRemoteDatasourceImpl implements PresenceRemoteDatasource {
  late DatabaseReference presenceRealtimeDB;

  PresenceRemoteDatasourceImpl() {
    presenceRealtimeDB = FirebaseDatabase.instance.ref(PresenceTree.node);
  }

  @override
  Stream<DatabaseEvent> getPresence({required String userID}) =>
      presenceRealtimeDB.child(userID).onValue;

  @override
  Future<void> updatePresence({required String userID}) async {
    await presenceRealtimeDB
        .child(userID)
        .update(_presenceStatus(status: true))
        .timeout(const Duration(seconds: 5));

    await presenceRealtimeDB
        .child(userID)
        .onDisconnect()
        .update(_presenceStatus(status: false))
        .timeout(
          const Duration(seconds: 5),
        );
  }

  Map<String, dynamic> _presenceStatus({required bool status}) => {
        PresenceTree.statusField: status,
        PresenceTree.timestampField: DateTime.now().toString(),
      };
}
