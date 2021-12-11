import 'package:flutter/material.dart';

/// State management for `AnimatedDrawer`
///
/// The [isOpen] state tells whether the drawer is open or not.
///
/// The [uniqueTag] state is a unique random string added after the `tag name`
/// of `bodyCtrl` and `drawerCtrl` of all AnimatedDrawer. For single AnimatedDrawer
/// this [unqiueTag] remains same. Dependency injection is done using `Get.put` for
/// bodyCtrl and drawerCtrl with tag names as `bodyCtrl<uniqueTag>` and
/// `drawerCtrl<uniqueTag>` respectively
///
/// The appbar `height` and its `drop shadow's opacity` changes as the user scrolls
class AnimatedDrawerProvider extends ChangeNotifier {
  late bool isOpen;
  late String uniqueTag;
  double appbarHeight = 80 + 32;
  double appbarBoxShadowOpacity = 0;

  AnimatedDrawerProvider({required this.uniqueTag}) {
    isOpen = false;
  }

  void toggleDrawerState() {
    isOpen = !isOpen;
    notifyListeners();
  }

  /// **Some math for dynamic height**
  /// - 0 - 96 scroll px
  /// - 80 + 32 = 112 -- 64 (height of appbar when we've scrolled 96px)
  /// - 112 - 64 == 49
  /// - 49 / 96 == 0.666 == 0.51
  ///
  /// **For dynamic opactiy**
  /// - 0 - 0.25
  /// - 0.25 / 96 == 0.0026
  void animateAppBar(double scrollPixelsValue) {
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
