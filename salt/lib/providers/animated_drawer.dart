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

  double appbarHeight = 80 + 32;
  double appbarBoxShadowOpacity = 0;

  void animateAppBar(double scrollPixelsValue) {
    /// Some math for height
    /// 0 - 96 scroll px
    /// 80 + 32 = 112 -- 64 (height of appbar when we've scrolled 96px)
    ///
    /// 112 - 64 == 49
    /// 49 / 96 == 0.666 == 0.51
    ///
    /// For opactiy
    /// 0 - 0.25
    /// 0.25 / 96 == 0.0026

    if (scrollPixelsValue <= 96) {
      appbarHeight = 112 - (scrollPixelsValue * 0.51);

      if (scrollPixelsValue == 0) {
        appbarBoxShadowOpacity = 0;
      } else {
        appbarBoxShadowOpacity = 0 + (scrollPixelsValue * 0.002604166666667);
      }
      notifyListeners();
    }
  }
}
