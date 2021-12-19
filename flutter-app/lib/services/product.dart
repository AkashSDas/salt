import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class ProductService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}product';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Get product for a tag
  Future<ApiResponse> getProductForTag(String tagId, {int? limit}) async {
    var res = await runAsync(
      Dio().get(
        limit == null
            ? '$baseURL/tag/$tagId'
            : '$baseURL/tag/$tagId?limit=$limit',
        options: options,
      ),
    );

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }

  Future<Map> saveProductToCart(Map product) async {
    /// Shape of `cart products` will be
    /// {
    ///   'cart-products': [
    ///       product1,
    ///       product2,
    ///       ...
    ///   ]
    /// }

    var _storage = const storage.FlutterSecureStorage();

    /// Check if cart exists
    final cartResponse = await runAsync(_storage.read(key: 'cart'));

    /// Any err
    if (cartResponse[1] != null) {
      return {
        'error': true,
        'msg': 'Something went wrong, Please try again',
      };
    }

    /// Cart doesn't exists
    if (cartResponse[0] == null) {
      final createResponse = await runAsync(
        _storage.write(key: 'cart', value: jsonEncode([product])),
      );

      /// Any err
      if (createResponse[1] != null) {
        return {
          'error': true,
          'msg': 'Something went wrong, Please try again',
        };
      }

      return {
        'error': false,
        'msg': 'Successfully added to cart',
      };
    }

    /// Cart exists

    /// Deserialize cart, cart here will be list of products
    List cart = jsonDecode(cartResponse[0]);

    /// Removing the product if the cart already had it
    cart = cart.where((prod) => prod['id'] != product['id']).toList();

    /// Then adding the item to the cart
    cart.add(product);
    final addResponse = await runAsync(
      _storage.write(key: 'cart', value: jsonEncode(cart)),
    );

    if (addResponse[1] != null) {
      return {
        'error': true,
        'msg': 'Something went wrong, Please try again',
      };
    }

    return {
      'error': false,
      'msg': 'Successfully added to cart',
    };
  }

  Future<List<CartProduct>> getCartProducts() async {
    var _storage = const storage.FlutterSecureStorage();
    final cartResponse = await runAsync(_storage.read(key: 'cart'));

    if (cartResponse[1] == null) {
      /// Empty cart
      if (cartResponse[0] == null) return [];
      List cart = jsonDecode(cartResponse[0]) as List;
      final products = cart.map((prod) => CartProduct.fromJson(prod)).toList();
      return products;
    } else {
      /// TODO: handle error in different way
      return [];
    }
  }

  Future<Map> removeProductFromCart(String id) async {
    var _storage = const storage.FlutterSecureStorage();
    List response = await runAsync(_storage.read(key: 'cart'));

    /// Any err
    if (response[1] != null) {
      return {'error': true, 'msg': 'Something went wrong, Please try again'};
    } else if (response[0] == null) {
      return {'error': true, 'msg': 'Cart is empty'};
    }

    /// Check here whether the cart is empty or not
    List cart = jsonDecode(response[0]);
    cart = cart.where((prod) => prod['id'] != id).toList();

    /// Saving the cart
    await runAsync(
      _storage.write(key: 'cart', value: jsonEncode(cart)),
    );
    return {'error': false, 'msg': 'Product removed'};
  }

  Future<void> updateProductQuantityInCart(String productId, int value) async {
    var _storage = const storage.FlutterSecureStorage();
    List response = await runAsync(_storage.read(key: 'cart'));

    /// Check here whether the cart is empty or not
    List cart = jsonDecode(response[0]);
    cart = cart.map((prod) {
      if (prod['id'] == productId) {
        return {
          ...(prod as Map),
          'quantitySelected': prod['quantitySelected'] + value,
        };
      } else {
        return prod;
      }
    }).toList();

    /// Saving the cart
    await runAsync(
      _storage.write(key: 'cart', value: jsonEncode(cart)),
    );
  }

  Future<double> getTotalCartPrice() async {
    var _storage = const storage.FlutterSecureStorage();
    final cartResponse = await runAsync(_storage.read(key: 'cart'));

    if (cartResponse[1] == null) {
      /// Empty cart
      if (cartResponse[0] == null) return 0;
      List cart = jsonDecode(cartResponse[0]) as List;
      double amount = 0;
      cart.forEach((prod) {
        amount = amount + prod['price'] * prod['quantitySelected'];
      });
      return amount;
    } else {
      /// TODO: handle error in different way
      return 0;
    }
  }

  /// Purchase products
  Future<Map> purchaseProducts({
    required List<CartProduct> products,
    required String token,
    required String userId,
    required String paymentMethod,
  }) async {
    /// Create orders
    final orders = products.map((prod) {
      return {
        'productId': prod.id,
        'sellerId': prod.user.id,
        'quantity': prod.quantitySelected,
        'price': prod.price,
      };
    }).toList();

    var res = await runAsync(
      Dio().post(
        '$baseURL/purchase/$userId',
        data: {
          'products': orders,
          'payment_method': paymentMethod,
        },
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ),
    );

    if (res[1] != null) {
      return {
        'error': true,
        'msg': 'Something went wrong, Please try again',
      };
    }

    var response = res[0] as Response;
    var data = response.data;
    if (data['error']) {
      return {'error': true, 'msg': data['msg']};
    }
    return {'error': false, 'msg': data['msg']};
  }

  Future<void> emptyCart() async {
    var _storage = const storage.FlutterSecureStorage();
    await runAsync(
      _storage.write(key: 'cart', value: jsonEncode([])),
    );
  }

  /// Get products paginated
  Future<ApiResponse> getProductsPagniated({
    int? limit,
    String? nextId,
  }) async {
    var url = baseURL;
    if (limit != null) url = '$baseURL?limit=$limit';
    if (nextId != null) url = '$baseURL?nextId=$nextId';
    if (limit != null && nextId != null) {
      url = '$baseURL?limit=$limit&next=$nextId';
    }
    var res = await runAsync(Dio().get(url, options: options));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }
}
