import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  double price; // price of 1 quantity
  int quantity = 1;
  double displayPrice;
  var loading = false;
  ProductProvider({required this.price}) : displayPrice = price;

  /// Update product quantity
  void updateProductQuantity(int amount) {
    quantity = quantity + amount;
    displayPrice = price * quantity;
    notifyListeners();
  }

  /// Update loading
  void updateLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
