import 'dart:async';

import 'package:chat_app/core/res/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppStateProvider extends ChangeNotifier {
  // Check connect Network
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _hasConnect = false;
  bool get hasConnect => _hasConnect;

  // setup dark mode
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  String _urlImage = '';
  String get urlImage => _urlImage;
  set urlImage(String url) {
    _urlImage = url;
    notifyListeners();
  }

  AppStateProvider() {
    // Initialized Connectivity
    _connectivity = Connectivity();
    // To get the realtime status of network
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      checkConnectionStatus,
    );

    // Init Repository
  }

  // post request change darkmode to server
  changeDarkMode(bool darkMode, String userID) async {
    _darkMode = darkMode;
    notifyListeners();

  }

  Future uploadAvatar(String path, String userID) async {

  }

  // Check connect network
  Future checkConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _hasConnect = false;
      notifyListeners();
    } else {
      _hasConnect = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
