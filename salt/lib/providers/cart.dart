import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:salt/models/cart_product/cart_product.dart';
import 'package:salt/services/product.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/alerts/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

class CartProvider extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> saveProductToCart(BuildContext context, Map product) async {
    final _service = ProductService();

    setLoading(true);
    await _service.saveProductToCart(product);
    setLoading(false);

    if (_service.error) {
      failedSnackBar(context: context, msg: _service.msg);
    } else {
      successSnackBar(context: context, msg: _service.msg);
    }
  }
}

class UserCartProvider extends ChangeNotifier {
  List<CartProduct> products = [];
  var loading = false;
  var error = false;
  var msg = '';

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getAll(BuildContext context) async {
    var _storage = const Storage.FlutterSecureStorage();
    setLoading(true);
    final cartResponse = await runAsync(_storage.read(key: 'cart'));
    setLoading(false);
    if (cartResponse[1] == null) {
      if (cartResponse[0] == null) {
        /// Empty cart
        msg = 'Cart is empty';
        successSnackBar(context: context, msg: msg);
        return;
      }
      List cart = jsonDecode(cartResponse[0]) as List;
      products = cart.map((prod) => CartProduct.fromJson(prod)).toList();
    } else {
      error = true;
      msg = 'Something went wrong, Please try again';
      failedSnackBar(context: context, msg: msg);
    }
    notifyListeners();
  }

  Future<void> removeProduct(String productId) async {
    final _service = ProductService();

    setLoading(true);
    await _service.removeProduct(productId);
    setLoading(false);

    if (!_service.error) {
      /// remove from products
      products = products.where((prod) => prod.id != productId).toList();
    }
    notifyListeners();
  }

  Future<void> updateProductQuantity(
    BuildContext context,
    String productId,
    int value,
  ) async {
    final _service = ProductService();
    await _service.updateProductQuantityInCart(productId, value);

    /// Update quantity in products
    products = products.map((prod) {
      if (prod.id == productId) {
        prod.quantity += value;
      }
      return prod;
    }).toList();

    if (_service.error) {
      failedSnackBar(context: context, msg: 'Something went wrong');
    }

    notifyListeners();
  }
}
