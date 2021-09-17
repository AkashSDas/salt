import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
