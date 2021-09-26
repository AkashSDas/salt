import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/product/product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as SecureStorage;

import '../utils.dart';

Future<dynamic> getAllProducts(
    {int? limit, bool? hasNext, String? nextId}) async {
  limit = limit != null ? limit : 10;

  String baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}product?limit=$limit';
  if (hasNext == true) {
    baseURL = '$baseURL&next=$nextId';
  }

  var response = await runAsync(
    Dio().get(
      baseURL,
      options: Options(validateStatus: (int? status) {
        return status! < 500;
      }),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;
    print(response);

    if (!response[0]['error']) {
      List<dynamic> products = response[0]['data']['products'];
      for (int i = 0; i < products.length; i++) {
        products[i] = Product.fromJson(products[i]);
      }
      response[0]['data']['products'] = products;
    }
  }

  return response;
}

Future<bool> saveProductsToCart(Map product) async {
  /// Shape of `cart products` will be
  /// {
  ///   'cart-products': [
  ///       product1,
  ///       product2,
  ///       ...
  ///   ]
  /// }

  final _storage = SecureStorage.FlutterSecureStorage();

  /// Check if cart exists
  final response = await runAsync(_storage.read(key: 'cart'));
  if (response[1] != null)
    return false;
  else if (response[0] == 0) {
    /// Create a new cart save data in it
    final res = await runAsync(
      _storage.write(key: 'cart', value: jsonEncode([product])),
    );
    if (res[1] != null) return false;
    return true;
  } else {
    /// Deserialize cart, cart here will be list of products
    List cart = jsonDecode(response[0]);

    /// Removing the product if the cart already had it
    cart.where((prod) => prod['id'] != product['id']);

    /// Then adding the item to the cart
    cart.add(product);
    final res = await runAsync(
      _storage.write(key: 'cart', value: jsonEncode(cart)),
    );
    if (res[1] != null) return false;
    return true;
  }
}

/// Get all cart products
Future<dynamic> getAllProductsInCart() async {
  final _storage = SecureStorage.FlutterSecureStorage();

  /// Check if cart exists
  return await runAsync(_storage.read(key: 'cart'));
}

/// Remove an item from cart
Future<bool> removeProductFromCart(String productId) async {
  final _storage = SecureStorage.FlutterSecureStorage();
  List response = await runAsync(_storage.read(key: 'cart'));
  if (response[1] != null) return false;

  /// Check here whether the cart is empty or not
  List cart = jsonDecode(response[0]);
  cart.where((prod) => prod['id'] != productId);

  /// Saving the cart
  await runAsync(
    _storage.write(key: 'cart', value: jsonEncode(cart)),
  );
  return true;
}
