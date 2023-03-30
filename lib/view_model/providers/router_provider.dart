import 'dart:developer';

import 'package:flutter/material.dart';

class RouterProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RouterProvider();

  String? getNamePath() {
    String? currentPath;
    if (navigatorKey.currentState == null) return null;

    bool predicate(Route<dynamic> route) {
      currentPath = route.settings.name;
      return true;
    }
    navigatorKey.currentState!.popUntil(predicate);
    log('🚀getNamePath⚡ ${currentPath ?? "No routes available"}');
    return currentPath;
  }
}
