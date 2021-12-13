import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class AuthService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}auth/';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  /// Sign up
  static Future<ApiResponse> signup(Map<String, dynamic> data) async {
    var res = await runAsync(
      Dio().post('${baseURL}signup', data: data, options: options),
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
