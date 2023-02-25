import 'dart:developer';
import 'dart:io';

import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../core/utils/constants.dart';

class ProfileRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  late CollectionReference profileDocument;

  ProfileRemoteDataSource() {
    profileDocument = firestore.collection('Profiles');
  }

  Future<String> getFile({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final refPath = "$filePath/$fileName";
      String downloadURL = await storage
          .ref(refPath)
          .getDownloadURL()
          .timeout(
            const Duration(seconds: 5),
          )
          .onError(
        (error, stackTrace) {
          return "";
        },
      );
      return downloadURL;
    } on FirebaseException catch (_) {
      return "";
    }
  }

  // @override
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

  Future<bool> uploadFile({
    required File file,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData,
  }) async {
    try {
      final refPath = "$filePath/$fileName";
      await storage
          .ref(refPath)
          .putFile(
            file,
            settableMetaData,
          )
          .then(
        (p0) async {
          return true;
        },
      );
    } on FirebaseException catch (e) {
      log(e.toString());
      return false;
    }
    return false;
  }

  Future<void> createProfile({required User authUser}) async {
    final profileMap = {
      AuthConstant.idUserField: authUser.uid,
      AuthConstant.emailField: authUser.email,
      AuthConstant.fullNameField: authUser.displayName,
      AuthConstant.urlImageField: "",
      AuthConstant.userMessagingTokenField: "",
    };

    await profileDocument.doc(authUser.uid).set(profileMap);
  }

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

    final snapshot = await profileDocument.doc(userID).get();

    if (!snapshot.exists || snapshot.id.isEmpty) return null;

    return snapshotDataToProfile(data: snapshot.data(), id: userID);
  }
}
