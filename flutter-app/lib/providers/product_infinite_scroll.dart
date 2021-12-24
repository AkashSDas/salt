import 'package:flutter/material.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/services/product.dart';

/// This provider will be used in case where the blog post listview
/// is wrapped with another listview and after reaching the end of
/// upper (parent) listview, more posts will be called and once received
/// then notifying the child listview having posts with the new posts
class ProductInfiniteScrollProvider extends ChangeNotifier {
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

  ProductInfiniteScrollProvider({int limit = 2}) {
    limit = limit;
  }

  /// FETCHING DATA

  Future<void> initialFetch() async {
    var _service = ProductService();

    setFirstLoading(true);
    var response = await _service.getProductsPagniated(limit: limit);
    setFirstLoading(false);

    /// Checking for error
    if (response.error) {
      firstError = true;
      firstApiResponseMsg = response.msg;
    } else {
      products = [
        ...products,
        ...(response.data['products'].map((prod) => Product.fromJson(prod)))
            .toList(),
      ];
      nextId = response.data['next'];
      reachedEnd = !response.data['hasNext'];
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    var _service = ProductService();

    setLoading(true);
    var response = await _service.getProductsPagniated(
      limit: limit,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (response.error) {
      error = true;
      apiResponseMsg = response.msg;
    } else {
      products = [
        ...products,
        ...(response.data['products'].map((prod) => Product.fromJson(prod)))
            .toList(),
      ];
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
