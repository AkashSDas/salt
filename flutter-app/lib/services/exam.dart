import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/utils/index.dart';

class ExamService {
  static var baseURL = '${dotenv.env["BACKEND_API_BASE_URL"]}exam';
  static var options = Options(validateStatus: (int? status) {
    return status! < 500;
  });

  Future<ApiResponse> getOrders() async {
    var url = baseURL;

    var res = await runAsync(Dio().get(
      url,
      options: Options(
        validateStatus: (int? status) => status! < 500,
      ),
    ));

    if (res[0] == null) {
      return ApiResponse(error: true, msg: ApiMessages.wentWrong, data: null);
    }

    Response apiRes = res[0] as Response;
    var result = apiRes.data;
    print(result);
    return ApiResponse(
      error: result['error'],
      msg: result['msg'],
      data: result['data'],
    );
  }
}
