import 'package:chat_app/data/datasources/remote_datasources/injector.dart';
import 'package:chat_app/models/injector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PresenceStreamWidget extends StatelessWidget {
  final String userId;
  final Widget Function(UserPresence?) child;
  const PresenceStreamWidget({
    Key? key,
    required this.child,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: PresenceRemoteDatasourceImpl().getPresence(userID: userId),
      builder: (context, snapshotDBEvnet) {
        final bool condition1 = snapshotDBEvnet.hasData;
        final bool condition2 = snapshotDBEvnet.data != null;
        final bool condition3 = snapshotDBEvnet.data?.snapshot.value != null;
        UserPresence? presence;
        if (condition1 && condition2 && condition3) {
          final data = snapshotDBEvnet.data!.snapshot;
          final mapStringDynamic = Map<String, dynamic>.from(data.value as Map);
          presence = UserPresence.fromMap(mapStringDynamic, data.key!);
        }
        return child(presence);
      },
    );
  }
}
