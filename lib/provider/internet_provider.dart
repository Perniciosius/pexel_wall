import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider with ChangeNotifier {
  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  InternetProvider() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        _hasInternet = false;
      } else {
        _hasInternet = true;
      }
      notifyListeners();
    });
  }
}
