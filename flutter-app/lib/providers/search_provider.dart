import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/models/product/product.dart';
import 'package:salt/services/post.dart';
import 'package:salt/services/product.dart';

/// [SearchProvider] is used for [SearchScreen]
class SearchProvider extends ChangeNotifier {
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

  final _productService = ProductService();
  final _postService = PostService();

  /// Search form data
  String query = '';

  var productLoading = false;
  var productReachedEnd = false;
  var postLoading = false;
  var postReachedEnd = false;

  /// Id, used to retrieve next set items (if there)
  String? nextPosts = '';
  String? nextProducts = '';

  /// Search items
  List<Product> products = [];
  List<Post> posts = [];

  /// SETTERS

  /// Query setter
  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setProductLoading(bool value) {
    productLoading = value;
    notifyListeners();
  }

  void setPostLoading(bool value) {
    postLoading = value;
    notifyListeners();
  }

  /// SEARCH FUNCTIONS

  /// Search for products
  Future<void> searchForProducts([int limit = 6]) async {
    setProductLoading(true);
    var result = await _productService.searchProducts(query, limit: limit);
    setProductLoading(false);
    if (result.error || result.data == null) return;
    nextProducts = result.data['next'];
    productReachedEnd = result.data['next'] == null ? true : false;
    products = [
      ...products,
      ...(result.data['products'].map((product) => Product.fromJson(product)))
          .toList(),
    ];
    notifyListeners();
  }

  /// Search for posts
  Future<void> searchForPosts([int limit = 6]) async {
    setPostLoading(true);
    var result = await _postService.searchPosts(query, limit: limit);
    setPostLoading(false);
    if (result.error || result.data == null) return;
    nextPosts = result.data['next'];
    postReachedEnd = result.data['next'] == null ? true : false;
    posts = [
      ...posts,
      ...(result.data['posts'].map((post) => Post.fromJson(post))).toList(),
    ];
    notifyListeners();
  }

  /// Query
  Future<void> searchForQuery() async {
    Future.wait([searchForPosts(), searchForProducts()]);
  }
}
