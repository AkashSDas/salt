import 'package:flutter/material.dart';
import 'package:salt/models/product_order/product_order.dart';
import 'package:salt/services/product_order.dart';

class ProductOrderInfiniteScrollProvider extends ChangeNotifier {
  var _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  var limit = 10;
  List<ProductOrder> orders = [];
  var loading = false;
  var reachedEnd = false;

  /// The firstLoading will be used for the first data fetching when
  /// the widget has mounted and then won't be used again during the
  /// lifecycle of that widget
  var firstLoading = false;
  var firstError = false;
  var firstApiResponseMsg = '';

  /// Info about next set of orders to fetch from backend
  var hasNext = false;
  var nextId = '';

  /// ERROR & MSG
  var error = false;
  var apiResponseMsg = '';

  ProductOrderInfiniteScrollProvider({int limit = 10}) {
    limit = limit;
  }

  // FETCHING DATA

  Future<void> fetchProductOrders(String userId, String token) async {
    var _service = ProductOrderService();

    setLoading(true);
    var response = await _service.getUserProductOrders(
      userId,
      token,
      limit,
      nextId,
    );
    setLoading(false);

    /// Checking for error
    if (response.error) {
      error = true;
      apiResponseMsg = response.msg;
    } else {
      List<ProductOrder> newOrders = [];
      for (int i = 0; i < response.data['orders'].length; i++) {
        final order = response.data['orders'][i];

        newOrders.add(
          ProductOrder.fromJson({
            'id': order['order']['id'],
            'price': order['order']['price'],
            'quantity': order['order']['quantity'],
            'feedback': order['feedback'],
            'product': order['order']['product'],
          }),
        );
      }

      orders = [...orders, ...newOrders];
      nextId = response.data['next'];
      reachedEnd = !response.data['hasNext'];
    }

    notifyListeners();
  }

  /// LOADERS

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setFirstLoading(bool value) {
    firstLoading = value;
    notifyListeners();
  }
}
