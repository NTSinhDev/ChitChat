import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:chat_app/core/enum/enums.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

abstract class PersonalInformationRemoteDataSource {
  Future<String?> getFile({required String filePath, required String fileName});
  Future<Profile?> getProfileById({required String userID});
  Future<Profile?> createProfile({required User authUser});
  Future<String?> uploadFile({
    required String image,
    required FileUploadType type,
    required String fileName,
    required String filePath,
    SettableMetadata? settableMetaData,
  });
  Future<List<Profile>> getAllProfile();
  Future<List<Profile>> getAllProfileByName({required String name});
}

class PersonalInformationRemoteDataSourceImpl
    implements PersonalInformationRemoteDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late CollectionReference _profileDocument;

  PersonalInformationRemoteDataSourceImpl() {
    _profileDocument = FirebaseFirestore.instance.collection(
      ProfileField.collectionName,
    );
  }

  @override
  Future<List<Profile>> getAllProfileByName({required String name}) async {
    final String text = "$name\uf8ff";
    return await _profileDocument
        .orderBy(ProfileField.fullNameField, descending: true)
        .where(ProfileField.fullNameField, isGreaterThanOrEqualTo: name)
        .where(ProfileField.fullNameField, isLessThanOrEqualTo: text)
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
                ParsedSnapshotData(parsedTo: ParsedTo.profile).to(
              data: queryDocSnapshot.data(),
              id: queryDocSnapshot.id,
            ) as Profile,
          )
          .toList(),
    );
  }

  @override
  Future<List<Profile>> getAllProfile() async {
    return await _profileDocument.get().then(
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
  Future<String?> getFile({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final String refPath = "$filePath/$fileName";
      String downloadURL = await _storage
          .ref(refPath)
          .getDownloadURL()
          .timeout(
            const Duration(seconds: 5),
          )
          .onError(
        (error, stackTrace) {
          log('🚀log⚡ $error');
          return "";
        },
      );

      return downloadURL.isEmpty ? null : downloadURL;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  @override
  Future<String?> uploadFile({
    required String image,
    required FileUploadType type,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData,
  }) async {
    String? urlImage;

    try {
      final path = "$filePath/$fileName";
      final file = type == FileUploadType.url
          ? await getImageFileFromNetwork(image, path)
          : File(image);
      if (file == null) return null;

      final storageRef = _storage.ref(path);

      await storageRef.putFile(file, settableMetaData);

      urlImage = await storageRef.getDownloadURL();

      return urlImage;
    } on FirebaseException catch (e) {
      log(e.toString());
      return urlImage;
    }
  }

  Future<File?> getImageFileFromNetwork(String url, String path) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      return null;
    }
  }

  @override
  Future<Profile?> createProfile({required User authUser}) async {
    final profileMap = {
      ProfileField.idUserField: authUser.uid,
      ProfileField.emailField: authUser.email,
      ProfileField.fullNameField: authUser.displayName,
      ProfileField.urlImageField: "",
      ProfileField.userMessagingTokenField: "",
    };

    await _profileDocument.doc(authUser.uid).set(profileMap);
    return await getProfileById(userID: authUser.uid);
  }

  @override
  Future<Profile?> getProfileById({required String userID}) async {
    // final profile = profileDocument.doc(userID).get().then(
    //   (snapshot) async {
    //     if (!snapshot.exists || snapshot.id.isEmpty) return null;

    //     return snapshotDataToProfile(
    //       data: snapshot.data(),
    //       id: userID,
    //     );
    //   },
    // );

    // return profile;

    final snapshot = await _profileDocument.doc(userID).get();

    if (!snapshot.exists || snapshot.id.isEmpty) return null;

    return ParsedSnapshotData(parsedTo: ParsedTo.profile).to(
      data: snapshot.data(),
      id: userID,
    ) as Profile;
  }

  //  @override
  // Future<void> uploadMultipleFile({
  //   required List<PlatformFile> listFile,
  //   required String path,
  // }) async {
  //   try {
  //     for (var element in listFile) {
  //       final file = File(element.path!);
  //       await uploadFile(
  //         file: file,
  //         filePath: path,
  //         fileName: element.name,
  //       );
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
}
