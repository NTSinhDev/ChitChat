import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class KeyRemoteDataSource {
  Future<String> getAPIKey();
}

class KeyRemoteDataSourceImpl implements KeyRemoteDataSource {
  late CollectionReference _keyCollection;
  KeyRemoteDataSourceImpl() {
    _keyCollection = FirebaseFirestore.instance.collection("APIKey");
  }

  @override
  Future<String> getAPIKey() async {
    try {
      return await _keyCollection.get().then((querySnapshot) {
        if (querySnapshot.size > 0) {
          return querySnapshot.docs.first.id;
        }
        return '';
      });
    } catch (e) {
      log('🚀getAPIKey⚡ ERROR \n${e.toString()}');
      return '';
    }
  }
}
