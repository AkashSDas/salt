import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/utils.dart';

Future<dynamic> getAllBlogPostsPaginated({
  int? limit,
  bool? hasNext,
  String? nextId,
}) async {
  limit = limit != null ? limit : 10;

  String baseURL =
      '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post?limit=$limit';
  if (hasNext == true) {
    baseURL = '$baseURL&next=$nextId';
  }

  var response = await runAsync(
    Dio().get(
      baseURL,
      options: Options(validateStatus: (int? status) {
        return status! < 500;
      }),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    if (!response[0]['error']) {
      List<dynamic> posts = response[0]['data']['posts'];
      for (int i = 0; i < posts.length; i++) {
        posts[i] = BlogPost.fromJson(posts[i]);
      }
      response[0]['data']['posts'] = posts;
    }
  }

  return response;
}

class NewBlogPost {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile coverImg;

  const NewBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    required this.coverImg,
  });
}

Future<dynamic> saveBlogPost(NewBlogPost post, String token) async {
  String baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post';

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

  var response = await runAsync(
    Dio().post(
      '$baseURL/${post.authorId}',
      data: formData,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    // if (!response[0]['error']) {
    //   var post = response[0]['data']['post'];
    //   post = BlogPost.fromJson(post);
    // }
    // response[0]['data']['post'] = post;
  }

  return response;
}

Future<dynamic> getAllBlogPostsForSingleUserPaginated({
  int? limit,
  bool? hasNext,
  String? nextId,
  required String userId,
  required String token,
}) async {
  limit = limit != null ? limit : 10;

  String baseURL =
      '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post/user/$userId?limit=$limit';
  if (hasNext == true) {
    baseURL = '$baseURL&next=$nextId';
  }

  var response = await runAsync(
    Dio().get(
      baseURL,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {'Authorization': 'Bearer $token'},
      ),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    print(response);

    if (!response[0]['error']) {
      List<dynamic> posts = response[0]['data']['posts'];
      for (int i = 0; i < posts.length; i++) {
        posts[i] = BlogPost.fromJson(posts[i]);
      }
      response[0]['data']['posts'] = posts;
    }
  }

  return response;
}

Future<dynamic> deleteUserBlogPost(
  String blogId,
  String userId,
  String token,
) async {
  String url = '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post/$blogId/$userId';

  var response = await runAsync(
    Dio().delete(
      url,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {'Authorization': 'Bearer $token'},
      ),
    ),
  );

  if (response[1] == null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;
    if (!response[0]['error']) return true;
  }

  return false;
}

class UpdateBlogPost {
  final String title;
  final String description;
  final String content;
  final List<String> categories;
  final String authorId;
  final XFile? coverImg;

  const UpdateBlogPost({
    required this.title,
    required this.description,
    required this.content,
    required this.categories,
    required this.authorId,
    this.coverImg,
  });
}

Future<dynamic> updateBlogPost(
  UpdateBlogPost post,
  String token,
  String postId,
  String userId,
) async {
  String baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}blog-post';

  /// read time
  int wordCount = post.content.trim().split(' ').length;
  double readTime = (wordCount / 100 + 1).roundToDouble();

  late FormData formData;

  /// image
  if (post.coverImg != null) {
    /// If user if updating the img

    String filename = post.coverImg!.path.split('/').last;

    String categoriesStr = '';
    post.categories.forEach((category) {
      categoriesStr = categoriesStr + '$category,';
    });
    categoriesStr = categoriesStr.substring(0, categoriesStr.length - 2);

    formData = FormData.fromMap({
      'title': post.title,
      'description': post.description,
      'content': post.content,
      'readTime': readTime,
      'author': post.authorId,
      'coverImg': await MultipartFile.fromFile(
        post.coverImg!.path,
        filename: filename,
      ),
      'categories': jsonEncode(post.categories),
    });
  } else {
    formData = FormData.fromMap({
      'title': post.title,
      'description': post.description,
      'content': post.content,
      'readTime': readTime,
      'author': post.authorId,
      'categories': jsonEncode(post.categories),
    });
  }

  var response = await runAsync(
    Dio().put(
      '$baseURL/$postId/$userId',
      data: formData,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    ),
  );

  if (response[0] != null) {
    Response<dynamic> res = response[0] as Response<dynamic>;
    response[0] = res.data;

    // if (!response[0]['error']) {
    //   var post = response[0]['data']['post'];
    //   post = BlogPost.fromJson(post);
    // }
    // response[0]['data']['post'] = post;
  }

  print(response);

  return response;
}
