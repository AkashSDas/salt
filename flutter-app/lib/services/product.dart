import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class ProductService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}product';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Get product for a tag
  Future<ApiResponse> getProductForTag(String tagId, {int? limit}) async {
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
}
