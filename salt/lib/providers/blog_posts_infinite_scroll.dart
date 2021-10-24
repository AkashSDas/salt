import 'package:flutter/cupertino.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/services/blog_post.dart';

/// This provider will be used in case where the blog post listview
/// is wrapped with another listview and after reaching the end of
/// upper (parent) listview, more posts will be called and once received
/// then notifying the child listview having posts with the new posts
class BlogPostsInfiniteScrollProvider extends ChangeNotifier {
  var limit = 2;

  BlogPostsInfiniteScrollProvider({int limit = 2}) {
    limit = limit;
  }

  List<BlogPost> posts = [];
  var loading = false;
  var reachedEnd = false;

  /// The firstLoading will be used for the first data fetching when
  /// the windet has mounted and then won't be used again during the
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
    BlogPostService _service = BlogPostService();

    setFirstLoading(true);
    var response = await _service.getPaginated(limit: limit);
    setFirstLoading(false);

    /// Checking for error
    if (_service.error) {
      firstError = true;
      firstApiResponseMsg = _service.msg;
    } else {
      posts = [...posts, ...response];
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    BlogPostService _service = BlogPostService();

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
      posts = [...posts, ...response];
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
