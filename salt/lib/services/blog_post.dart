import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/utils/index.dart';

class BlogPostService {
  late bool error;
  late String msg;

  var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post/';
  var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  BlogPostService() {
    error = false;
    msg = '';
  }

  /// return [error, data]
  Future<List<dynamic>> sanitizeResponse(Future dioPromise) async {
    var result = await runAsync(dioPromise);

    /// No error
    if (result[0] != null) {
      Response<dynamic> response = result[0] as Response;
      var data = response.data;

      if (data['error']) {
        /// Error in backend
        error = true;
        msg = data['error'];
      } else {
        return [false, data['data']];
      }
    } else {
      error = true;
      msg = 'Something went wrong';
    }

    return [true, null];
  }

  /// Get all categories (paginated)
  Future<List<BlogPost>> getPaginated({
    int limit = 10,
    bool? hasNext,
    String? nextId,
  }) async {
    var result = await sanitizeResponse(
      Dio().get('$baseURL?limit=$limit', options: options),
    );

    if (result[0]) return [];
    var data = result[1];

    List<BlogPost> posts = [];
    for (int i = 0; i < data['posts'].length; i++) {
      posts.add(BlogPost.fromJson(data['posts'][i]));
    }
    return posts;
  }
}
