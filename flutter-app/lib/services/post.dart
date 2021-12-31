import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/models/tag/tag.dart';
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

  /// Update user post
  Future<ApiResponse> updatePost(
      UpdatePost post, String userId, String token) async {
    late FormData formData;

    if (post.coverImg != null) {
      /// Update post with cover img

      String filename = post.coverImg!.path.split('/').last;

      formData = FormData.fromMap({
        'title': post.title,
        'description': post.description,
        'content': post.content,
        'coverImg': await MultipartFile.fromFile(
          post.coverImg!.path,
          filename: filename,
        ),
        'tags': jsonEncode(post.tags),
        'published': post.published,
      });
    } else {
      formData = FormData.fromMap({
        'title': post.title,
        'description': post.description,
        'content': post.content,
        'tags': jsonEncode(post.tags),
        'published': post.published,
      });
    }

    var res = await runAsync(Dio().put(
      '$baseURL/$userId/${post.id}',
      data: formData,
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
      data: result['post'],
    );
  }

  /// Get posts related to a tag
  ///
  /// If tags is empty then latest [limit] posts will be displayed.
  /// If tags is not empty then the first tagId from tags will be used to
  /// get latest [limit] posts which have that first tag, if in this case the
  /// tag has no post then it will revert back to getting the latest [limit]
  /// posts that can be any tag.
  ///
  /// This service should be used get [limit] related posts and if you want
  /// all posts having certain tag (as here this service is getting [limit] posts
  /// for the first tag in [tags], if available)
  Future<ApiResponse> getRelatedPosts(List<Tag> tags, int limit) async {
    /// URL for getting latest posts `with any tag`
    var anyPostsURL = '$baseURL?limit=$limit';

    /// URL for getting latest posts `with the tags[0]`
    String? tagPostsURL;
    if (tags.isNotEmpty) {
      tagPostsURL = '$baseURL/tag/${tags[0].id}?limit=$limit';
    }

    /// Check if `tag has any post`
    if (tagPostsURL != null) {
      var checkResponse = await runAsync(
        Dio().get('$baseURL/tag/${tags[0].id}?limit=1', options: options),
      );

      if (checkResponse[0] == null) {
        return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
      }

      Response checkRes = checkResponse[0] as Response;
      var checkResult = checkRes.data;

      if (checkResult['data'] == null) {
        /// This means that `tag[0]` has no posts
        /// This won't return anything that the control flow will
        /// go to getting latest posts `with any tag`
      } else {
        /// This means that `tag[0]` has posts

        var tagResponse = await runAsync(
          Dio().get(tagPostsURL, options: options),
        );

        if (tagResponse[0] == null) {
          return ApiResponse(
            error: true,
            msg: ApiMessages.wentWrong,
            data: null,
          );
        }

        Response tagRes = tagResponse[0] as Response;
        var tagResult = tagRes.data;

        return ApiResponse(
          error: tagResult['error'],
          msg: tagResult['msg'],
          data: tagResult['data'],
        );
      }
    }

    /// Getting latest posts `with any tag`

    var res = await runAsync(Dio().get(anyPostsURL, options: options));

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

  /// Search for posts
  Future<ApiResponse> searchPosts(
    String query, {
    int? limit,
    String? next,
  }) async {
    var url = '$baseURL/search';
    if (limit != null) url = '$baseURL/search?limit=$limit';
    if (next != null) url = '$baseURL/search?next=$next';
    if (limit != null && next != null) {
      url = '$baseURL/search?limit=$limit&next=$next';
    }

    var res = await runAsync(Dio().post(
      url,
      data: {'searchQuery': query},
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (int? status) => status! < 500,
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
}
