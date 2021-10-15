import 'package:flutter/material.dart';

class BlogPostScrollEvent extends ChangeNotifier {
  bool _isScrolling;

  BlogPostScrollEvent(this._isScrolling);

  bool get isScrolling => _isScrolling;

  set isScrolling(bool scrollStatus) {
    _isScrolling = scrollStatus;
    notifyListeners();
  }
}
