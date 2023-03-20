import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utils/injector.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

abstract class StorageRemoteDatasource {
  Future<String?> getFile({required String filePath, required String fileName});
  Future<String?> uploadFile({
    required String path,
    required FileUploadType type,
    required String fileName,
    required String folderName,
    SettableMetadata? settableMetaData,
  });
  Future<void> uploadMultipleFile({
    required List<String> paths,
    required List<String> names,
    required String folderName,
  });
}

class StorageRemoteDatasourceImpl implements StorageRemoteDatasource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
          log('🚀log⚡ lỗi ko lấy được ảnh trên firebase $error');
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
    required String path, // path or url
    required FileUploadType type,
    required String folderName,
    required String fileName,
    SettableMetadata? settableMetaData,
  }) async {
    String? urlImage;

    try {
      final pathStorage = "$folderName/$fileName";
      final file = type == FileUploadType.url
          ? await _getImageFileFromNetwork(path, pathStorage)
          : File(path);
      if (file == null) return null;
      final storageRef = _storage.ref(pathStorage);
      await storageRef.putFile(file, settableMetaData);
      urlImage = await storageRef.getDownloadURL();
      return urlImage;
    } on FirebaseException catch (e) {
      log(e.toString());
      return urlImage;
    }
  }

  Future<File?> _getImageFileFromNetwork(String url, String path) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      return null;
    } catch (e) {
      log('🚀log⚡ lỗi khi lấy ảnh từ netword || ${e.toString()}');
      return null;
    }
  }

  @override
  Future<void> uploadMultipleFile({
    required List<String> paths,
    required List<String> names,
    required String folderName,
  }) async {
    try {
      for (int i = 0; i < paths.length; i++) {
        await uploadFile(
          path: paths[i],
          type: FileUploadType.path,
          folderName: folderName,
          fileName: names[i],
        );
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
