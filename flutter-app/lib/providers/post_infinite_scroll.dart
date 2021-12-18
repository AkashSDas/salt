import 'package:flutter/material.dart';
import 'package:salt/models/post/post.dart';
import 'package:salt/services/post.dart';

class PostInfiniteScrollProvider extends ChangeNotifier {
  var limit = 10;
  List<Post> posts = [];
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

  PostInfiniteScrollProvider({int limit = 2}) {
    limit = limit;
  }

  // FETCHING DATA

  Future<void> initialFetch() async {
    var _service = PostService();

    setFirstLoading(true);
    var response = await _service.getPostsPagniated(limit: limit);
    setFirstLoading(false);

    /// Checking for error
    if (response.error) {
      firstError = true;
      firstApiResponseMsg = response.msg;
    } else {
      posts = [
        ...posts,
        ...(response.data['posts'].map((post) => Post.fromJson(post))).toList(),
      ];
      nextId = response.data['next'];
      reachedEnd = !response.data['hasNext'];
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    var _service = PostService();

    setLoading(true);
    var response = await _service.getPostsPagniated(
      limit: limit,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (response.error) {
      error = true;
      apiResponseMsg = response.msg;
    } else {
      posts = [
        ...posts,
        ...(response.data['posts'].map((post) => Post.fromJson(post))).toList(),
      ];
      nextId = response.data['next'];
      reachedEnd = !response.data['hasNext'];
    }

    notifyListeners();
  }

  Future<void> initialFetchUserPosts(String userId, String token) async {
    var _service = PostService();

    setFirstLoading(true);
    var response = await _service.getPostsOfUserPagniated(
      userId,
      token,
      limit: limit,
    );
    setFirstLoading(false);

    /// Checking for error
    if (response.error) {
      firstError = true;
      firstApiResponseMsg = response.msg;
    } else {
      posts = [
        ...posts,
        ...(response.data['posts'].map((post) => Post.fromJson(post))).toList(),
      ];
      nextId = response.data['next'];
      reachedEnd = !response.data['hasNext'];
    }

    notifyListeners();
  }

  Future<void> fetchMoreUserPosts(String userId, String token) async {
    var _service = PostService();

    setLoading(true);
    var response = await _service.getPostsOfUserPagniated(
      userId,
      token,
      limit: limit,
      nextId: nextId,
    );
    setLoading(false);

    /// Checking for error
    if (response.error) {
      error = true;
      apiResponseMsg = response.msg;
    } else {
      posts = [
        ...posts,
        ...(response.data['posts'].map((post) => Post.fromJson(post))).toList(),
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

  void setPosts(List<Post> value) {
    posts = value;
    notifyListeners();
  }
}
