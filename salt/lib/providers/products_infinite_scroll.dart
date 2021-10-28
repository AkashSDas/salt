import 'package:flutter/cupertino.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/services/product.dart';

class ProductsInfiniteScrollProvider extends ChangeNotifier {
  var limit = 10;

  ProductsInfiniteScrollProvider({int limit = 10}) {
    limit = limit;
  }

  List<Product> products = [];
  var loading = false;
  var reachedEnd = false;

  /// The firstLoading will be used for the first data fetching when
  /// the widget has mounted and then won't be used again during the
  /// lifecycle of that widget
  var firstLoading = false;
  var firstError = false;
  var firstApiResponseMsg = '';

  /// Info about next set of posts to fetch from backend
  var hasNext = false;
  var nextId = '';

  /// ERROR & MSG
  var error = false;
  var apiResponseMsg = '';

  /// FETCHING DATA

  Future<void> initialFetch() async {
    final _service = ProductService();

    setFirstLoading(true);
    var response = await _service.getPaginated(limit: limit);
    setFirstLoading(false);

    /// Checking for error
    if (_service.error) {
      firstError = true;
      firstApiResponseMsg = _service.msg;
    } else {
      products = [...products, ...response];
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    final _service = ProductService();

    setLoading(true);
    var response = await _service.getPaginated(
      limit: limit,
      hasNext: hasNext,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (_service.error) {
      error = true;
      apiResponseMsg = _service.msg;
    } else {
      products = [...products, ...response];
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
