import 'package:flutter/material.dart';

class AnimatedDrawerProvider extends ChangeNotifier {
  late bool isDrawerOpen;

  AnimatedDrawerProvider() {
    isDrawerOpen = false;
  }

  void toggleDrawerState() {
    isDrawerOpen = !isDrawerOpen;
    notifyListeners();
  }
}
