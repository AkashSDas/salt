import 'package:flutter/material.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/services/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartProduct> products = [];

  /// Update products
  void updateProducts(List<CartProduct> value) {
    products = value;
    notifyListeners();
  }

  Future<List<CartProduct>> getCartProducts() async {
    final service = ProductService();
    final prods = await service.getCartProducts(); // products
    updateProducts(prods);
    return prods;
  }

  Future<void> updateCartProductQuantity(String productId, int value) async {
    final service = ProductService();
    await service.updateProductQuantityInCart(productId, value);

    /// Update quantity in products for UI
    products = products.map((prod) {
      if (prod.id == productId) prod.quantitySelected += value;
      return prod;
    }).toList();

    notifyListeners();
  }
}
