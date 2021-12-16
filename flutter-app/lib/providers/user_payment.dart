import 'package:flutter/material.dart';

class UserPaymentProvider extends ChangeNotifier {
  /// User payment cards saved
  List cards = [];

  var loading = false;

  /// Update cards
  void updateCards(List value) {
    cards = value;
    notifyListeners();
  }

  /// Update loading
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
