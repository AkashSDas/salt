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

  // No results found
  var productsNotFound = false;
  var postsNotFound = false;

  /// Load more
  var moreLoading = false;

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

  void setMoreLoading(bool value) {
    moreLoading = value;
    notifyListeners();
  }

  /// SEARCH FUNCTIONS

  /// Search for products
  Future<void> searchForProducts([int limit = 2]) async {
    setProductLoading(true);
    var result = await _productService.searchProducts(query, limit: limit);
    setProductLoading(false);
    if (result.error || result.data == null) return;
    nextProducts = result.data['next'];
    productReachedEnd = result.data['next'] == null ? true : false;

    List<Product> newProducts = [];
    for (var i = 0; i < result.data['products'].length; i++) {
      newProducts.add(Product.fromJson(result.data['products'][i]));
    }
    if (newProducts.isEmpty) productsNotFound = true;

    products = [...products, ...newProducts];
    notifyListeners();
  }

  /// Search for more products
  Future<void> searchForMoreProducts([int? limit = 2]) async {
    setMoreLoading(true);
    var result = await _productService.searchProducts(
      query,
      limit: limit,
      next: nextProducts,
    );
    setMoreLoading(false);
    if (result.error || result.data == null) return;
    nextProducts = result.data['next'];
    productReachedEnd = result.data['next'] == null ? true : false;

    List<Product> newProducts = [];
    for (var i = 0; i < result.data['products'].length; i++) {
      newProducts.add(Product.fromJson(result.data['products'][i]));
    }
    if (newProducts.isEmpty) productsNotFound = true;

    products = [...products, ...newProducts];
    notifyListeners();
  }

  /// Search for posts
  Future<void> searchForPosts([int limit = 2, moreLoading = false]) async {
    setProductLoading(true);
    var result = await _postService.searchPosts(query, limit: limit);
    setProductLoading(false);
    if (result.error || result.data == null) return;
    nextPosts = result.data['next'];
    postReachedEnd = result.data['next'] == null ? true : false;

    List<Post> newPosts = [];
    for (var i = 0; i < result.data['posts'].length; i++) {
      newPosts.add(Post.fromJson(result.data['posts'][i]));
    }
    if (newPosts.isEmpty) postsNotFound = true;

    posts = [...posts, ...newPosts];
    notifyListeners();
  }

  /// Search for more posts
  Future<void> searchForMorePosts([int? limit = 2]) async {
    setMoreLoading(true);
    var result = await _postService.searchPosts(
      query,
      limit: limit,
      next: nextPosts,
    );
    setMoreLoading(false);
    if (result.error || result.data == null) return;
    nextPosts = result.data['next'];
    postReachedEnd = result.data['next'] == null ? true : false;

    List<Post> newPosts = [];
    for (var i = 0; i < result.data['posts'].length; i++) {
      newPosts.add(Post.fromJson(result.data['posts'][i]));
    }
    if (newPosts.isEmpty) postsNotFound = true;

    posts = [...posts, ...newPosts];
    notifyListeners();
  }

  /// Query
  Future<void> searchForQuery() async {
    posts = [];
    products = [];
    postsNotFound = false;
    productsNotFound = false;
    notifyListeners();
    Future.wait([searchForPosts(), searchForProducts()]);
  }

  SearchProvider();

  SearchProvider.fromQuery({required String searchQuery}) {
    query = searchQuery;
  }
}
