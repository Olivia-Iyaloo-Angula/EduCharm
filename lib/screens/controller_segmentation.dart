import 'package:flutter/material.dart';

class ControllerSegmentation extends ChangeNotifier {
  int total = 0;
  bool generateWord = false;

  void setUp({required int total}) {
    this.total = total;
    notifyListeners();
  }

  void requestWord({required bool request}) {
    generateWord = request;
    notifyListeners();
  }
}
