import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/cart_product.dart/cart_product.dart';
import 'package:salt/models/tag/tag.dart';
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

  /// Get products related to a tag
  ///
  /// If tags is empty then latest [limit] product will be displayed.
  /// If tags is not empty then the first tagId from tags will be used to
  /// get latest [limit] products which have that first tag, if in this case the
  /// tag has no products then it will revert back to getting the latest [limit]
  /// products that can be any tag.
  ///
  /// This service should be used get [limit] related products and if you want
  /// all products having certain tag (as here this service is getting [limit] products
  /// for the first tag in [tags], if available)
  Future<ApiResponse> getRelatedProducts(List<Tag> tags, int limit) async {
    /// URL for getting latest products `with any tag`
    var anyProductsURL = '$baseURL?limit=$limit';

    /// URL for getting latest products `with the tags[0]`
    String? tagProductsURL;
    if (tags.isNotEmpty) {
      tagProductsURL = '$baseURL/tag/${tags[0].id}?limit=$limit';
    }

    /// Check if `tag has any post`
    if (tagProductsURL != null) {
      var checkResponse = await runAsync(
        Dio().get('$baseURL/tag/${tags[0].id}?limit=1', options: options),
      );

      if (checkResponse[0] == null) {
        return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
      }

      Response checkRes = checkResponse[0] as Response;
      var checkResult = checkRes.data;

      if (checkResult['data'] == null) {
        /// This means that `tag[0]` has no product
        /// This won't return anything that the control flow will
        /// go to getting latest products `with any tag`
      } else {
        /// This means that `tag[0]` has products

        var tagResponse = await runAsync(
          Dio().get(
            '$baseURL/tag/${tags[0].id}?limit=$limit',
            options: options,
          ),
        );

        if (tagResponse[0] == null) {
          return ApiResponse(
            error: true,
            msg: ApiMessages.wentWrong,
            data: null,
          );
        }

        Response tagRes = tagResponse[0] as Response;
        var tagResult = tagRes.data;

        return ApiResponse(
          error: tagResult['error'],
          msg: tagResult['msg'],
          data: tagResult['data'],
        );
      }
    }

    /// Getting latest products `with any tag`

    var res = await runAsync(Dio().get(anyProductsURL, options: options));

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
