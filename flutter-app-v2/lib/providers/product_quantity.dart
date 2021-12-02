import 'package:flutter/cupertino.dart';

class ProductQuantityProvider extends ChangeNotifier {
  int quantity = 1;

  ProductQuantityProvider({int quantity = 1}) {
    quantity = quantity;
  }

  void increment() {
    quantity += 1;
    notifyListeners();
  }

  void decrement() {
    quantity -= 1;
    notifyListeners();
  }
}
