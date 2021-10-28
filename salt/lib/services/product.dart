import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/utils/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

class ProductService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}product/';
  var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  ProductService() {
    error = false;
    msg = '';
  }

  /// return [error, data]
  Future<List<dynamic>> sanitizeResponse(Future dioPromise) async {
    var result = await runAsync(dioPromise);

    /// No error
    if (result[0] != null) {
      Response<dynamic> response = result[0] as Response;
      var data = response.data;
      msg = data['message'];

      if (data['error']) {
        /// Error in backend
        error = true;
      } else {
        return [false, data['data']];
      }
    } else {
      error = true;
      msg = 'Something went wrong';
    }

    return [true, null];
  }

  /// Get all products
  Future<List<Product>> getPaginated({
    int limit = 10,
    bool? hasNext,
    String? nextId,
  }) async {
    var result = await sanitizeResponse(
      Dio().get('$baseURL?limit=$limit', options: options),
    );

    if (result[0]) return [];
    var data = result[1];

    List<Product> products = [];
    for (int i = 0; i < data['products'].length; i++) {
      products.add(Product.fromJson(data['products'][i]));
    }
    return products;
  }

  Future<void> saveProductToCart(Map product) async {
    /// Shape of `cart products` will be
    /// {
    ///   'cart-products': [
    ///       product1,
    ///       product2,
    ///       ...
    ///   ]
    /// }

    var _storage = const Storage.FlutterSecureStorage();

    /// Check if cart exists
    final cartResponse = await runAsync(_storage.read(key: 'cart'));
    if (cartResponse[1] != null) {
      /// error
      error = true;
      msg = 'Something went wrong, Please try again';
      return;
    }

    if (cartResponse[0] == null) {
      /// Cart doesn't exists

      final createResponse = await runAsync(
        _storage.write(key: 'cart', value: jsonEncode([product])),
      );

      if (createResponse[1] != null) {
        /// error
        error = true;
        msg = 'Something went wrong, Please try again';
        return;
      }
      msg = 'Successfully added to cart';
      return;
    }

    /// Cart exists
    /// Deserialize cart, cart here will be list of products
    List cart = jsonDecode(cartResponse[0]);

    /// Removing the product if the cart already had it
    cart.where((prod) => prod['id'] != product['id']);

    /// Then adding the item to the cart
    cart.add(product);
    final addResponse = await runAsync(
      _storage.write(key: 'cart', value: jsonEncode(cart)),
    );

    if (addResponse[1] != null) {
      /// error
      error = true;
      msg = 'Something went wrong, Please try again';
      return;
    }

    msg = 'Successfully added to cart';
  }
}
