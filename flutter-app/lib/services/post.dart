import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/utils/post_editor.dart';

class PostService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}post';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  Future<Map> savePost(CreatePost post, String userId, String token) async {
    /// image
    String filename = post.coverImg.path.split('/').last;

    final formData = FormData.fromMap({
      'title': post.title,
      'description': post.description,
      'content': post.content,
      'coverImg': await MultipartFile.fromFile(
        post.coverImg.path,
        filename: filename,
      ),
      'tags': jsonEncode(post.tags),
      'published': post.published,
    });

    var res = await runAsync(
      Dio().post(
        '$baseURL/$userId',
        data: formData,
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (res[1] != null) {
      return {
        'error': true,
        'msg': 'Something went wrong, Please try again',
      };
    }

    var response = res[0] as Response;
    var data = response.data;
    if (data['error']) {
      return {'error': true, 'msg': data['msg']};
    }
    return {
      'error': false,
      'msg': data['msg'],
      'data': data['post'],
    };
  }

  /// Get posts paginated
  Future<ApiResponse> getPostsPagniated({
    int? limit,
    String? nextId,
  }) async {
    var url = baseURL;
    if (limit != null) url = '$baseURL?limit=$limit';
    if (nextId != null) url = '$baseURL?nextId=$nextId';
    if (limit != null && nextId != null) {
      url = '$baseURL?limit=$limit&next=$nextId';
    }
    var res = await runAsync(Dio().get(url, options: options));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }

  /// Get post for a tag
  Future<ApiResponse> getPostsForTag(String tagId, {int? limit}) async {
    var res = await runAsync(
      Dio().get(
        limit == null
            ? '$baseURL/tag/$tagId'
            : '$baseURL/tag/$tagId?limit=$limit',
        options: options,
      ),
    );

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }

  /// Get posts with tags
  Future<ApiResponse> getPostsWithTags(
    List<String> tagIds, {
    int? limit,
  }) async {
    var tagIdsParam = tagIds.join('-');

    var res = await runAsync(
      Dio().get(
        limit == null
            ? '$baseURL/tag/$tagIdsParam'
            : '$baseURL/tag/$tagIdsParam?limit=$limit',
        options: options,
      ),
    );

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }

  /// Get posts of a user paginated
  Future<ApiResponse> getPostsOfUserPagniated(
    String userId,
    String token, {
    int? limit,
    String? nextId,
  }) async {
    var url = baseURL;
    if (limit != null) url = '$baseURL?limit=$limit';
    if (nextId != null) url = '$baseURL?nextId=$nextId';
    if (limit != null && nextId != null) {
      url = '$baseURL/$userId?limit=$limit&next=$nextId';
    }
    var res = await runAsync(Dio().get(
      url,
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {'Authorization': 'Bearer $token'},
      ),
    ));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }

  /// Delete user post
  Future<ApiResponse> deletePost(
      String postId, String userId, String token) async {
    var res = await runAsync(Dio().delete(
      '$baseURL/$userId/$postId',
      options: Options(
        validateStatus: (int? status) => status! < 500,
        headers: {'Authorization': 'Bearer $token'},
      ),
    ));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    return ApiResponse(error: result['error'], msg: result['msg'], data: null);
  }
}
