import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/blog_post/blog_post.dart';
import 'package:salt/utils/blog_post_editor.dart';
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
      msg = data['message'];

      if (data['error']) {
        /// Error in backend
        error = true;
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

  /// Save post
  Future<dynamic> savePost(CreateBlogPost post, String token) async {
    /// read time
    int wordCount = post.content.trim().split(' ').length;
    double readTime = (wordCount / 100 + 1).roundToDouble();

    /// image
    String filename = post.coverImg.path.split('/').last;

    FormData formData = FormData.fromMap({
      'title': post.title,
      'description': post.description,
      'content': post.content,
      'readTime': readTime,
      'author': post.authorId,
      'coverImg': await MultipartFile.fromFile(
        post.coverImg.path,
        filename: filename,
      ),
      'categories': jsonEncode(post.categories),
    });

    var response = await sanitizeResponse(
      Dio().post(
        '$baseURL/${post.authorId}',
        data: formData,
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (response[0]) return null;
    return response[1]['post'];
  }

  /// Get all post for loggedin user
  Future<List<BlogPost>> getPaginatedForLoggedInUser({
    int limit = 10,
    required String userId,
    required String token,
    bool? hasNext,
    String? nextId,
  }) async {
    String url = '$baseURL/user/$userId?limit=$limit';
    if (nextId != null) url = '$url&next=$nextId';

    var result = await sanitizeResponse(
      Dio().get(
        url,
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (result[0]) return [];
    var data = result[1];

    List<BlogPost> posts = [];
    for (int i = 0; i < data['posts'].length; i++) {
      posts.add(BlogPost.fromJson(data['posts'][i]));
    }
    return posts;
  }

  /// Delete post
  Future<void> deletePost(String blogId, String userId, String token) async {
    String url = '$baseURL$blogId/$userId';
    await sanitizeResponse(
      Dio().delete(
        url,
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );
  }
}
