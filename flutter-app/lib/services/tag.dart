import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class TagService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}tag';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Get a tag
  Future<ApiResponse> getTag(String id) async {
    var res = await runAsync(Dio().get('$baseURL/$id', options: options));

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
