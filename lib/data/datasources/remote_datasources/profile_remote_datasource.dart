import 'dart:developer';
import 'dart:isolate';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileRemoteDataSource {
  Future<Profile?> getProfileById({required String userID});
  Future<Profile?> createProfile({required User authUser});
  Future<List<Profile>> getAllProfile();
  Future<List<Profile>> getAllProfileByName({required String name});
  Future<bool> updateProfile({
    required Map<String, dynamic> data,
    required String userID,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  late CollectionReference _profileCollection;

  ProfileRemoteDataSourceImpl() {
    _profileCollection = FirebaseFirestore.instance.collection(
      ProfileField.collectionName,
    );
  }

  @override
  Future<bool> updateProfile({
    required Map<String, dynamic> data,
    required String userID,
  }) async {
    try {
      await _profileCollection.doc(userID).update(data);
      return true;
    } catch (e) {
      log('🚀updateProfile⚡ ERROR:\n ${e.toString()}');
      return false;
    }
  }

  @override
  Future<List<Profile>> getAllProfileByName({required String name}) async {
    final String text = "$name\uf8ff";
    return await _profileCollection
        .orderBy(ProfileField.fullName, descending: true)
        .where(ProfileField.fullName, isGreaterThanOrEqualTo: name)
        .where(ProfileField.fullName, isLessThanOrEqualTo: text)
        .get()
        .then(
      (querySnapshot) async {
        if (_isNullQuerySnapshot(querySnapshot)) return [];

        final ReceivePort receivePort = ReceivePort();
        final isolates = await Isolate.spawn(
          _parsedListUserProfile,
          [receivePort.sendPort, querySnapshot.docs],
        );
        final data = (await receivePort.first) as List<Profile>;
        isolates.kill(priority: Isolate.immediate);
        return data;
      },
    );
  }

  bool _isNullQuerySnapshot(QuerySnapshot<Object?> querySnapshot) =>
      querySnapshot.size == 0 && querySnapshot.docs.isNotEmpty;

  void _parsedListUserProfile(List<dynamic> message) {
    SendPort sendPort = message[0];
    final listValues = message[1] as List<QueryDocumentSnapshot<Object?>>;
    sendPort.send(
      listValues
          .map(
            (queryDocSnapshot) =>
                ParsedSnapshotData(parsedTo: ParsedTo.profile).parsed(
              data: queryDocSnapshot.data(),
              id: queryDocSnapshot.id,
            ) as Profile,
          )
          .toList(),
    );
  }

  @override
  Future<List<Profile>> getAllProfile() async {
    return await _profileCollection.get().then(
      (querySnapshot) async {
        if (_isNullQuerySnapshot(querySnapshot)) return [];

        final ReceivePort receivePort = ReceivePort();
        final isolates = await Isolate.spawn(
          _parsedListUserProfile,
          [receivePort.sendPort, querySnapshot.docs],
        );
        final data = (await receivePort.first) as List<Profile>;
        isolates.kill(priority: Isolate.immediate);
        return data;
      },
    );
  }

  @override
  Future<Profile?> createProfile({required User authUser}) async {
    final profileMap = {
      ProfileField.idUser: authUser.uid,
      ProfileField.email: authUser.email,
      ProfileField.fullName: authUser.displayName,
      ProfileField.urlImage: "",
      ProfileField.userMessagingToken: "",
    };

    await _profileCollection.doc(authUser.uid).set(profileMap);
    return await getProfileById(userID: authUser.uid);
  }

  Future<String> createNewProfile(String name) async {
    final data = Profile(email: 'Virtual', fullName: name).toMap();
    return await _profileCollection.add(data).then((doc) {
      doc.set(Profile(id: doc.id, email: 'Virtual', fullName: name).toMap());
      return doc.id;
    });
  }

  @override
  Future<Profile?> getProfileById({required String userID}) async {
    return await _profileCollection.doc(userID).get().then(
      (snapshot) async {
        if (!snapshot.exists || snapshot.id.isEmpty) return null;

        return ParsedSnapshotData(parsedTo: ParsedTo.profile).parsed(
          data: snapshot.data(),
          id: userID,
        ) as Profile;
      },
    );
  }
}
