import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salt/models/blog-post/blog-post.dart';
import 'package:salt/models/user/user.dart';
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
    'categories': post.categories,
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
