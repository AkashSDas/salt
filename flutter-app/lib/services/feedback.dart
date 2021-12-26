import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class FeedbackService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}feedback';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Create feedback
  Future<Map> saveFeedback(
    int rating,
    String comment,
    String orderId,
    String productId,
    String userId,
    String token,
  ) async {
    var res = await runAsync(
      Dio().post(
        '$baseURL/$userId/$orderId/$productId',
        data: {'rating': rating, 'comment': comment},
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
      'data': data['data'],
    };
  }

  /// Delete feedback
  Future<ApiResponse> deleteFeedback(
    String feedbackId,
    String userId,
    String token,
  ) async {
    var res = await runAsync(
      Dio().delete(
        '$baseURL/$userId/$feedbackId',
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (res[1] != null) {
      return ApiResponse(
        error: true,
        msg: 'Something went wrong, Please try again',
        data: null,
      );
    }

    var response = res[0] as Response;
    var data = response.data;
    if (data['error']) {
      return ApiResponse(
        error: true,
        msg: data['msg'],
        data: null,
      );
    }

    return ApiResponse(
      error: false,
      msg: data['msg'],
      data: null,
    );
  }

  /// Update feedback
  Future<ApiResponse> updateFeedback(
    String feedbackId,
    int rating,
    String comment,
    String userId,
    String token,
  ) async {
    var res = await runAsync(
      Dio().put(
        '$baseURL/$userId/$feedbackId',
        data: {'rating': rating, 'comment': comment},
        options: Options(
          validateStatus: (int? status) => status! < 500,
          headers: {'Authorization': 'Bearer $token'},
        ),
      ),
    );

    if (res[1] != null) {
      return ApiResponse(
        error: true,
        msg: 'Something went wrong, Please try again',
        data: null,
      );
    }

    var response = res[0] as Response;
    var data = response.data;
    if (data['error']) {
      return ApiResponse(
        error: true,
        msg: data['msg'],
        data: null,
      );
    }

    return ApiResponse(
      error: false,
      msg: data['msg'],
      data: null,
    );
  }
}
