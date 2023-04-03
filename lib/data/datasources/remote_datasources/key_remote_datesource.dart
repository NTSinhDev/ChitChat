import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class KeyRemoteDataSource {
  Future<List<String>> getAPIKey();
}

class KeyRemoteDataSourceImpl implements KeyRemoteDataSource {
  late CollectionReference _keyCollection;
  KeyRemoteDataSourceImpl() {
    _keyCollection = FirebaseFirestore.instance.collection("APIKey");
  }

  @override
  Future<List<String>> getAPIKey() async {
    try {
      return await _keyCollection.get().then((querySnapshot) {
        if (querySnapshot.size > 0) {
          return querySnapshot.docs.map((docSnapshot) {
            return docSnapshot.id;
          }).toList();
        }
        return [];
      });
    } catch (e) {
      log('🚀getAPIKey⚡ ERROR \n${e.toString()}');
      return [];
    }
  }
}
