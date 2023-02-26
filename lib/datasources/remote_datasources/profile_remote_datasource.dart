import 'dart:developer';
import 'dart:io';

import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/constants.dart';

abstract class ProfileRemoteDataSource {
  Future<String?> getFile({required String filePath, required String fileName});
  Future<Profile?> getProfileById({required String userID});
  Future<Profile?> createProfile({required User authUser});
  Future<String?> uploadFile({
    required String url,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late CollectionReference _profileDocument;

  ProfileRemoteDataSourceImpl() {
    _profileDocument = _firestore.collection('Profiles');
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
    required String url,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData,
  }) async {
    String? urlImage;

    try {
      final file = await getImageFileFromNetwork(url);
      if (file == null) return null;

      final storageRef = _storage.ref("$filePath/$fileName");

      await storageRef.putFile(file, settableMetaData);

      urlImage = await storageRef.getDownloadURL();

      return urlImage;
    } on FirebaseException catch (e) {
      log(e.toString());
      return urlImage;
    }
  }

  Future<File?> getImageFileFromNetwork(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var file = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      return null;
    }
  }

  @override
  Future<Profile?> createProfile({required User authUser}) async {
    final profileMap = {
      AuthConstant.idUserField: authUser.uid,
      AuthConstant.emailField: authUser.email,
      AuthConstant.fullNameField: authUser.displayName,
      AuthConstant.urlImageField: "",
      AuthConstant.userMessagingTokenField: "",
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

    return snapshotDataToProfile(data: snapshot.data(), id: userID);
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
